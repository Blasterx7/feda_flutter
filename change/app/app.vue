<script setup>
useHead({
  meta: [
    { name: 'viewport', content: 'width=device-width, initial-scale=1' }
  ],
  link: [
    { rel: 'icon', href: '/favicon.ico' }
  ],
  htmlAttrs: {
    lang: 'en'
  }
})

const title = 'feda_flutter — Changelog'
const description = 'Release notes and changelog for feda_flutter, a Dart/Flutter package for FedaPay payments.'

useSeoMeta({
  title,
  description,
  ogTitle: title,
  ogDescription: description
})
</script>

<template>
  <UApp>
    <div class="min-h-screen xl:grid xl:grid-cols-2">
      <UPageSection
        title="Changelog"
        description="Release notes for feda_flutter — a Dart/Flutter package to integrate FedaPay payments."
        orientation="vertical"
        :links="[{
          label: 'pub.dev',
          icon: 'i-simple-icons-dart',
          variant: 'ghost',
          size: 'md',
          to: 'https://pub.dev/packages/feda_flutter',
          target: '_blank'
        }, {
          label: 'GitHub',
          icon: 'i-simple-icons-github',
          variant: 'ghost',
          size: 'md',
          to: 'https://github.com/Blasterx7/feda_flutter',
          target: '_blank'
        }]"
        :ui="{
          root: 'border-b border-default xl:border-b-0 xl:sticky xl:inset-y-0 xl:h-screen overflow-hidden',
          container: 'h-full items-center justify-center',
          wrapper: 'flex flex-col',
          headline: 'mb-6',
          title: 'text-left text-4xl',
          description: 'text-left max-w-lg',
          links: 'gap-1 justify-start -ms-2.5'
        }"
      >
        <template #top>
          <SkyBg />

          <div class="absolute -right-1/2 z-[-1] rounded-full bg-primary blur-[300px] size-60 sm:size-100 transform -translate-y-1/2 top-1/2" />
        </template>

        <template #headline>
          <AppLogo class="w-auto h-6 shrink-0 text-highlighted" />
        </template>

        <template #default />
      </UPageSection>

      <section class="px-4 sm:px-6 xl:px-0 xl:-ms-30 xl:flex-1">
        <UColorModeButton class="fixed top-4 right-4 z-10" />

        <NuxtPage />
      </section>
    </div>
  </UApp>
</template>
