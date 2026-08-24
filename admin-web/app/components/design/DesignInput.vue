<script setup lang="ts">
import { Field } from '@ark-ui/vue'

interface Props {
  label?: string
  placeholder?: string
  type?: 'text' | 'email' | 'url' | 'date' | 'time' | 'password'
  disabled?: boolean
  required?: boolean
  invalid?: boolean
  helperText?: string
  errorText?: string
  icon?: string
}

withDefaults(defineProps<Props>(), {
  label: undefined,
  placeholder: undefined,
  type: 'text',
  helperText: undefined,
  errorText: undefined,
  icon: undefined
})

const model = defineModel<string>()
</script>

<template>
  <Field.Root :disabled="disabled" :required="required" :invalid="invalid">
    <Field.Label v-if="label" class="text-body-3 text-text-muted mb-1 block">
      {{ label }}
    </Field.Label>
    <div class="relative">
      <Icon
        v-if="icon"
        :name="icon"
        class="text-text-hint pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2"
      />
      <Field.Input
        v-model="model"
        :type="type"
        :placeholder="placeholder"
        class="border-border-1 text-body-3 text-text-default placeholder:text-text-hint data-invalid:border-semantic-error w-full rounded-xl border py-2 pr-3 disabled:cursor-not-allowed disabled:opacity-50"
        :class="icon ? 'pl-9' : 'pl-3'"
      />
    </div>
    <Field.HelperText
      v-if="helperText && !invalid"
      class="text-caption-1 text-text-hint mt-1"
    >
      {{ helperText }}
    </Field.HelperText>
    <Field.ErrorText
      v-if="errorText"
      class="text-caption-1 text-semantic-error mt-1"
    >
      {{ errorText }}
    </Field.ErrorText>
  </Field.Root>
</template>
