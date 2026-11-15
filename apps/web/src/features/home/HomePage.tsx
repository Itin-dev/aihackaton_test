import { useTranslation } from 'react-i18next'
import { Link } from 'react-router'
import { buttonVariants } from '@/components/ui/button'
import { ToggleGroup, ToggleGroupItem } from '@/components/ui/toggle-group'
import { ThemeToggle } from '@/features/theme/ThemeToggle'
import { LANGUAGES } from '@/i18n'
import { cn } from '@/lib/utils'
import { TOPICS } from './topics'

export default function HomePage() {
  const { t, i18n } = useTranslation()

  return (
    <>
      <header className="flex items-start justify-between gap-4">
        <div className="flex flex-col gap-2">
          <h1 className="text-3xl font-bold tracking-tight">{t('home.title')}</h1>
          <p className="text-lg text-muted-foreground">{t('home.intro')}</p>
        </div>
        <ThemeToggle />
      </header>

      <section aria-labelledby="language-heading" className="flex flex-col gap-3">
        <h2 id="language-heading" className="text-xl font-semibold">
          {t('home.language')}
        </h2>
        <ToggleGroup
          aria-labelledby="language-heading"
          variant="outline"
          className="grid w-full grid-cols-2 sm:grid-cols-4"
          value={[i18n.resolvedLanguage ?? 'en']}
          onValueChange={(value) => {
            if (value[0]) void i18n.changeLanguage(value[0])
          }}
        >
          {LANGUAGES.map((language) => (
            <ToggleGroupItem
              key={language.code}
              value={language.code}
              lang={language.code}
              dir={language.dir}
              className="h-12 text-base aria-pressed:border-primary aria-pressed:bg-primary aria-pressed:text-primary-foreground hover:aria-pressed:bg-primary/90 hover:aria-pressed:text-primary-foreground [&:lang(ar)]:text-lg"
            >
              {language.name}
            </ToggleGroupItem>
          ))}
        </ToggleGroup>
      </section>

      <section aria-labelledby="topics-heading" className="flex flex-col gap-3">
        <h2 id="topics-heading" className="text-xl font-semibold">
          {t('home.topics')}
        </h2>
        <nav aria-labelledby="topics-heading">
          <ul className="grid grid-cols-2 gap-3 sm:grid-cols-3">
            {TOPICS.map(({ id, Icon, urgent }) => (
              <li key={id} className={cn(urgent && 'col-span-2 sm:col-span-3')}>
                <Link
                  to={`/topic/${id}`}
                  className={cn(
                    buttonVariants({ variant: urgent ? 'destructive' : 'outline' }),
                    'h-auto min-h-28 w-full flex-col gap-3 p-4 text-base whitespace-normal',
                    '[&_svg:not([class*=size-])]:size-8',
                  )}
                >
                  <Icon aria-hidden="true" />
                  <span>{t(`topics.${id}`)}</span>
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </section>
    </>
  )
}
