<script setup lang="ts">
definePageMeta({ layout: false })

useHead({ title: 'Logg inn' })

const { login } = useAuth()
const route = useRoute()

const email = ref('')
const password = ref('')
const error = ref<string | null>(null)
const loading = ref(false)

async function submit() {
  if (loading.value) return
  error.value = null
  loading.value = true
  try {
    await login(email.value, password.value)
    const redirect =
      typeof route.query.redirect === 'string' ? route.query.redirect : '/'
    await navigateTo(redirect)
  } catch {
    error.value = 'Feil e-post eller passord'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex min-h-screen items-center justify-center p-4">
    <form
      class="gradient-border bg-surface-raise shadow-floating flex w-full max-w-sm flex-col gap-6 rounded-3xl p-8"
      @submit.prevent="submit"
    >
      <div class="flex flex-col items-center gap-3 text-center">
        <LogoSymbol class="h-8" />
        <h1 class="text-heading-3 text-text-default">BCC Media Admin</h1>
        <p class="text-body-3 text-text-muted">Logg inn for å fortsette</p>
      </div>

      <div class="flex flex-col gap-4">
        <DesignInput
          v-model="email"
          label="E-post"
          type="email"
          placeholder="deg@bcc.media"
          required
        />
        <DesignInput
          v-model="password"
          label="Passord"
          type="password"
          placeholder="••••••••"
          required
        />
      </div>

      <DesignBanner v-if="error" variant="error" icon="tabler:x">
        {{ error }}
      </DesignBanner>

      <DesignButton
        variant="primary"
        size="medium"
        :loading="loading"
        :disabled="loading"
        type="submit"
        @click="submit"
      >
        {{ loading ? 'Logger inn…' : 'Logg inn' }}
      </DesignButton>
    </form>
  </div>
</template>
