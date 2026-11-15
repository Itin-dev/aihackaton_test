"""HTTP entrypoint. Keep routes thin; put logic in separate modules."""

from typing import Annotated

from fastapi import Depends, FastAPI
from pydantic import BaseModel, Field

from app.config import Settings, get_settings
from app.llm import LLM, get_llm

app = FastAPI(title="api")


class ChatRequest(BaseModel):
    message: str = Field(min_length=1, max_length=4000)


class ChatResponse(BaseModel):
    reply: str


@app.get("/api/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/api/chat")
def chat(
    request: ChatRequest,
    llm: Annotated[LLM, Depends(get_llm)],
    settings: Annotated[Settings, Depends(get_settings)],
) -> ChatResponse:
    messages = [
        {"role": "system", "content": settings.system_prompt},
        {"role": "user", "content": request.message},
    ]
    return ChatResponse(reply=llm.complete(messages))
