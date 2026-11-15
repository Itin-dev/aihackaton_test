import { Route, Routes } from 'react-router'
import ChatDemo from '@/features/chat/ChatDemo'
import HomePage from '@/features/home/HomePage'
import TopicPage from '@/features/topic/TopicPage'
import Footer from '@/Footer'
import '@/i18n'

/** Routes only; providers (router, theme) are set up in main.tsx. */
export default function App() {
  return (
    <div className="mx-auto flex min-h-dvh max-w-2xl flex-col gap-8 px-4 py-6">
      <main className="flex flex-col gap-8">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/topic/:topicId" element={<TopicPage />} />
          <Route path="/chat" element={<ChatDemo />} />
        </Routes>
      </main>
      <Footer
        commit={import.meta.env.VITE_COMMIT_SHA ?? ''}
        env={import.meta.env.VITE_DEPLOY_ENV ?? ''}
      />
    </div>
  )
}
