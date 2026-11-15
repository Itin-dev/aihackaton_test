import pytest
from fastapi.testclient import TestClient

from app.config import Settings, get_settings
from app.llm import get_llm
from app.main import app


class FakeLLM:
    def __init__(self) -> None:
        self.calls: list[list[dict[str, str]]] = []

    def complete(self, messages: list[dict[str, str]]) -> str:
        self.calls.append(messages)
        return f"echo: {messages[-1]['content']}"


@pytest.fixture
def client():
    yield TestClient(app)
    app.dependency_overrides.clear()


def test_health(client):
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_chat_returns_llm_reply(client):
    fake = FakeLLM()
    app.dependency_overrides[get_llm] = lambda: fake
    response = client.post("/api/chat", json={"message": "Hello"})
    assert response.status_code == 200
    assert response.json() == {"reply": "echo: Hello"}
    assert fake.calls[0][-1] == {"role": "user", "content": "Hello"}


def test_chat_sends_system_prompt_first(client):
    fake = FakeLLM()
    app.dependency_overrides[get_llm] = lambda: fake
    client.post("/api/chat", json={"message": "Hi"})
    assert fake.calls[0][0]["role"] == "system"


def test_chat_rejects_empty_message(client):
    app.dependency_overrides[get_llm] = FakeLLM
    response = client.post("/api/chat", json={"message": ""})
    assert response.status_code == 422


def test_chat_without_api_key_is_503(client):
    app.dependency_overrides[get_settings] = lambda: Settings(openrouter_api_key="")
    response = client.post("/api/chat", json={"message": "Hello"})
    assert response.status_code == 503
    assert "OPENROUTER_API_KEY" in response.json()["detail"]
