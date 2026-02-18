export default defineAppConfig({
  ui: {
    colors: {
      primary: 'green',
      neutral: 'slate'
    },
    footer: {
      slots: {
        root: 'border-t border-default',
        left: 'text-sm text-muted'
      }
    }
  },
  seo: {
    siteName: 'feda_flutter'
  },
  header: {
    title: 'feda_flutter',
    to: '/',
    logo: {
      alt: 'feda_flutter',
      light: '',
      dark: ''
    },
    search: true,
    colorMode: true,
    links: [{
      'icon': 'i-simple-icons-github',
      'to': 'https://github.com/Blasterx7/feda_flutter',
      'target': '_blank',
      'aria-label': 'GitHub'
    }, {
      'icon': 'i-simple-icons-dart',
      'to': 'https://pub.dev/packages/feda_flutter',
      'target': '_blank',
      'aria-label': 'pub.dev'
    }]
  },
  footer: {
    credits: `feda_flutter • © ${new Date().getFullYear()}`,
    colorMode: false,
    links: [{
      'icon': 'i-simple-icons-github',
      'to': 'https://github.com/Blasterx7/feda_flutter',
      'target': '_blank',
      'aria-label': 'GitHub'
    }, {
      'icon': 'i-simple-icons-dart',
      'to': 'https://pub.dev/packages/feda_flutter',
      'target': '_blank',
      'aria-label': 'pub.dev'
    }]
  },
  toc: {
    title: 'Table of Contents',
    bottom: {
      title: 'Community',
      edit: 'https://github.com/Blasterx7/feda_flutter/edit/main/docs/content',
      links: [{
        icon: 'i-lucide-star',
        label: 'Star on GitHub',
        to: 'https://github.com/Blasterx7/feda_flutter',
        target: '_blank'
      }, {
        icon: 'i-simple-icons-dart',
        label: 'View on pub.dev',
        to: 'https://pub.dev/packages/feda_flutter',
        target: '_blank'
      }]
    }
  }
})
