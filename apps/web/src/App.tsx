import { type FormEvent, useState } from 'react'
import Footer from './Footer'

type Status = 'idle' | 'loading' | 'error'

export default function App() {
  const [message, setMessage] = useState('')
  const [reply, setReply] = useState('')
  const [error, setError] = useState('')
  const [status, setStatus] = useState<Status>('idle')

  async function send(event: FormEvent) {
    event.preventDefault()
    setStatus('loading')
    setError('')
    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message }),
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.detail ?? 'Request failed')
      setReply(data.reply)
      setStatus('idle')
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Request failed')
      setStatus('error')
    }
  }

  return (
    <main className="mx-auto flex min-h-screen max-w-2xl flex-col gap-6 p-6">
      <h1 className="text-3xl font-bold">Hackathon skeleton</h1>
      <form onSubmit={send} className="flex gap-2">
        <label htmlFor="message" className="sr-only">
          Message
        </label>
        <input
          id="message"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          placeholder="Ask something…"
          className="flex-1 rounded-lg border border-gray-700 bg-gray-900 px-4 py-2 text-gray-100 placeholder:text-gray-400 focus:border-blue-500 focus:outline-none"
        />
        <button
          type="submit"
          disabled={!message.trim() || status === 'loading'}
          className="rounded-lg bg-blue-600 px-4 py-2 font-medium text-white hover:bg-blue-500 disabled:opacity-50"
        >
          {status === 'loading' ? 'Sending…' : 'Send'}
        </button>
      </form>
      {error && (
        <p role="alert" className="rounded-lg border border-red-900 bg-red-950 p-4 text-red-300">
          {error}
        </p>
      )}
      {reply && <p className="whitespace-pre-wrap rounded-lg bg-gray-900 p-4">{reply}</p>}
      <Footer
        commit={import.meta.env.VITE_COMMIT_SHA ?? ''}
        env={import.meta.env.VITE_DEPLOY_ENV ?? ''}
      />
    </main>
  )
}
