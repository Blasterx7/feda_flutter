<script setup lang="ts">
defineProps<{
  title?: string
  description?: string
  headline?: string
}>()
</script>

<template>
  <div class="h-full w-full flex items-center justify-center bg-slate-950 text-white p-12 relative overflow-hidden font-sans">
    <div class="absolute inset-0 z-0 opacity-20">
      <div class="absolute -right-1/4 -top-1/4 w-1/2 h-1/2 bg-green-500 rounded-full blur-[100px]" />
      <div class="absolute -left-1/4 -bottom-1/4 w-1/2 h-1/2 bg-blue-500 rounded-full blur-[100px]" />
    </div>

    <div class="relative z-10 flex flex-col items-start max-w-2xl">
      <div v-if="headline" class="text-green-400 font-mono text-xl mb-4 font-bold tracking-tight">
        {{ headline }}
      </div>
      <h1 v-if="title" class="text-6xl font-bold mb-6 tracking-tight leading-tight">
        {{ title }}
      </h1>
      <p v-if="description" class="text-2xl text-slate-400 leading-relaxed">
        {{ description }}
      </p>
    </div>

    <div class="absolute bottom-12 left-12 flex items-center gap-2">
      <span class="font-mono font-bold tracking-tight text-3xl">
        <span class="text-green-400">feda</span>_flutter
      </span>
    </div>
  </div>
</template>
