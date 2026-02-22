// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: [
    '@nuxt/eslint',
    '@nuxt/ui',
    '@nuxtjs/mdc',
    '@nuxtjs/sitemap',
    'nuxt-og-image',
    'nuxt-llms',
    '@nuxtjs/mcp-toolkit'
  ],

  site: {
    url: 'https://feda-flutter-changelog.pages.dev',
    name: 'feda_flutter Changelog',
    description: 'Release notes and changelog for feda_flutter, a Dart/Flutter package for FedaPay payments.',
    defaultLocale: 'en'
  },

  devtools: {
    enabled: true
  },

  css: ['~/assets/css/main.css'],

  mdc: {
    highlight: {
      langs: ['diff', 'ts', 'vue', 'css']
    },
    remarkPlugins: {
      'remark-github': {
        options: {
          repository: 'Blasterx7/feda_flutter'
        }
      }
    }
  },

  ui: {
    theme: {
      defaultVariants: {
        color: 'neutral'
      }
    }
  },

  routeRules: {
    '/': { prerender: true }
  },

  compatibilityDate: '2025-01-15',

  sitemap: {
    strictNuxtContentPaths: true,
    xsl: false
  },

  llms: {
    domain: 'https://feda-flutter-changelog.pages.dev/',
    title: 'feda_flutter Changelog',
    description: 'Release notes and changelog for feda_flutter.',
    full: {
      title: 'feda_flutter - Changelog',
      description: 'Changelog history.'
    },
    sections: []
  },

  mcp: {
    name: 'feda_flutter changelog'
  },

  eslint: {
    config: {
      stylistic: {
        commaDangle: 'never',
        braceStyle: '1tbs'
      }
    }
  }
})
