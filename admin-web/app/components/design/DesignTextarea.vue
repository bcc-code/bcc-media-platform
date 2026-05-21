<script setup lang="ts">
import { Field } from '@ark-ui/vue'

interface Props {
  label?: string
  placeholder?: string
  rows?: number
  disabled?: boolean
  required?: boolean
  invalid?: boolean
  helperText?: string
  errorText?: string
}

withDefaults(defineProps<Props>(), {
  label: undefined,
  placeholder: undefined,
  rows: 4,
  helperText: undefined,
  errorText: undefined
})

const model = defineModel<string>()
</script>

<template>
  <Field.Root :disabled="disabled" :required="required" :invalid="invalid">
    <Field.Label v-if="label" class="text-body-3 text-text-muted mb-1 block">
      {{ label }}
    </Field.Label>
    <Field.Textarea
      v-model="model"
      :placeholder="placeholder"
      :rows="rows"
      autoresize
      class="border-border-1 text-body-3 text-text-default placeholder:text-text-hint data-invalid:border-semantic-error min-h-24 w-full resize-y rounded-xl border px-3 py-2 disabled:cursor-not-allowed disabled:opacity-50"
    />
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
