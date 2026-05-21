<script setup lang="ts">
import { Field, DatePicker, parseDate, type DateValue } from '@ark-ui/vue'

interface Props {
  label?: string
  placeholder?: string
  disabled?: boolean
  required?: boolean
  invalid?: boolean
  helperText?: string
  errorText?: string
}

withDefaults(defineProps<Props>(), {
  label: undefined,
  placeholder: 'Velg dato',
  helperText: undefined,
  errorText: undefined
})

const model = defineModel<string>()

const dateValue = computed<DateValue[]>({
  get() {
    if (!model.value) return []
    try {
      return [parseDate(model.value)]
    } catch {
      return []
    }
  },
  set(values: DateValue[]) {
    model.value = values[0]?.toString() ?? ''
  }
})
</script>

<template>
  <Field.Root :disabled="disabled" :required="required" :invalid="invalid">
    <Field.Label v-if="label" class="text-body-3 text-text-muted mb-1 block">
      {{ label }}
    </Field.Label>

    <DatePicker.Root
      v-model="dateValue"
      locale="nb-NO"
      :start-of-week="1"
      :positioning="{ placement: 'bottom-start', gutter: 4 }"
      :disabled="disabled"
      close-on-select
    >
      <DatePicker.Control class="flex">
        <DatePicker.Trigger
          class="border-border-1 bg-surface-default text-body-2 text-text-default not-disabled:hover:bg-surface-indent data-invalid:border-semantic-error flex w-full cursor-pointer items-center justify-between gap-2 rounded-xl border px-4 py-2.5 duration-150 disabled:cursor-not-allowed disabled:opacity-50"
        >
          <DatePicker.ValueText :placeholder="placeholder" />
          <Icon name="tabler:calendar" class="text-text-hint size-4" />
        </DatePicker.Trigger>
      </DatePicker.Control>

      <Teleport to="#teleports">
        <DatePicker.Positioner>
          <DatePicker.Content
            class="gradient-border bg-surface-raise shadow-floating ease-out-expo origin-[--transform-origin] rounded-xl p-4 data-[state=closed]:scale-95 data-[state=closed]:opacity-0 data-[state=open]:scale-100 data-[state=open]:opacity-100"
          >
            <DatePicker.View view="day">
              <DatePicker.Context v-slot="datePicker">
                <DatePicker.ViewControl
                  class="mb-3 flex items-center justify-between"
                >
                  <DatePicker.PrevTrigger
                    class="hover:bg-surface-indent inline-flex size-8 cursor-pointer items-center justify-center rounded-lg"
                  >
                    <Icon name="tabler:chevron-left" class="size-4" />
                  </DatePicker.PrevTrigger>
                  <DatePicker.ViewTrigger
                    class="text-title-3 text-text-default hover:bg-surface-indent cursor-pointer rounded-lg px-2 py-1"
                  >
                    <DatePicker.RangeText />
                  </DatePicker.ViewTrigger>
                  <DatePicker.NextTrigger
                    class="hover:bg-surface-indent inline-flex size-8 cursor-pointer items-center justify-center rounded-lg"
                  >
                    <Icon name="tabler:chevron-right" class="size-4" />
                  </DatePicker.NextTrigger>
                </DatePicker.ViewControl>

                <DatePicker.Table>
                  <DatePicker.TableHead>
                    <DatePicker.TableRow>
                      <DatePicker.TableHeader
                        v-for="weekDay in datePicker.weekDays"
                        :key="weekDay.short"
                        class="text-caption-1 text-text-hint size-9 font-medium"
                      >
                        {{ weekDay.narrow }}
                      </DatePicker.TableHeader>
                    </DatePicker.TableRow>
                  </DatePicker.TableHead>
                  <DatePicker.TableBody>
                    <DatePicker.TableRow
                      v-for="(week, weekIndex) in datePicker.weeks"
                      :key="weekIndex"
                    >
                      <DatePicker.TableCell
                        v-for="day in week"
                        :key="day.toString()"
                        :value="day"
                      >
                        <DatePicker.TableCellTrigger
                          class="group text-body-3 hover:bg-surface-indent data-selected:bg-primary-default data-selected:text-on-primary data-outside-range:text-text-hint data-disabled:text-text-hint relative inline-flex size-9 cursor-pointer flex-col items-center justify-center rounded-lg data-disabled:cursor-not-allowed"
                        >
                          {{ day.day }}
                          <span
                            class="bg-primary-default absolute bottom-1.25 hidden h-0.75 w-3 rounded-full group-data-today:block"
                          />
                        </DatePicker.TableCellTrigger>
                      </DatePicker.TableCell>
                    </DatePicker.TableRow>
                  </DatePicker.TableBody>
                </DatePicker.Table>
              </DatePicker.Context>
            </DatePicker.View>

            <DatePicker.View view="month">
              <DatePicker.Context v-slot="datePicker">
                <DatePicker.ViewControl
                  class="mb-3 flex items-center justify-between"
                >
                  <DatePicker.PrevTrigger
                    class="hover:bg-surface-indent inline-flex size-8 cursor-pointer items-center justify-center rounded-lg"
                  >
                    <Icon name="tabler:chevron-left" class="size-4" />
                  </DatePicker.PrevTrigger>
                  <DatePicker.ViewTrigger
                    class="text-title-3 text-text-default hover:bg-surface-indent cursor-pointer rounded-lg px-2 py-1"
                  >
                    <DatePicker.RangeText />
                  </DatePicker.ViewTrigger>
                  <DatePicker.NextTrigger
                    class="hover:bg-surface-indent inline-flex size-8 cursor-pointer items-center justify-center rounded-lg"
                  >
                    <Icon name="tabler:chevron-right" class="size-4" />
                  </DatePicker.NextTrigger>
                </DatePicker.ViewControl>

                <DatePicker.Table>
                  <DatePicker.TableBody>
                    <DatePicker.TableRow
                      v-for="(months, rowIndex) in datePicker.getMonthsGrid({
                        columns: 4,
                        format: 'short'
                      })"
                      :key="rowIndex"
                    >
                      <DatePicker.TableCell
                        v-for="month in months"
                        :key="month.label"
                        :value="month.value"
                      >
                        <DatePicker.TableCellTrigger
                          class="text-body-3 hover:bg-surface-indent data-selected:bg-primary-default data-selected:text-on-primary w-full cursor-pointer rounded-lg px-3 py-2 text-center"
                        >
                          {{ month.label }}
                        </DatePicker.TableCellTrigger>
                      </DatePicker.TableCell>
                    </DatePicker.TableRow>
                  </DatePicker.TableBody>
                </DatePicker.Table>
              </DatePicker.Context>
            </DatePicker.View>

            <DatePicker.View view="year">
              <DatePicker.Context v-slot="datePicker">
                <DatePicker.ViewControl
                  class="mb-3 flex items-center justify-between"
                >
                  <DatePicker.PrevTrigger
                    class="hover:bg-surface-indent inline-flex size-8 cursor-pointer items-center justify-center rounded-lg"
                  >
                    <Icon name="tabler:chevron-left" class="size-4" />
                  </DatePicker.PrevTrigger>
                  <DatePicker.ViewTrigger
                    class="text-title-3 text-text-default hover:bg-surface-indent cursor-pointer rounded-lg px-2 py-1"
                  >
                    <DatePicker.RangeText />
                  </DatePicker.ViewTrigger>
                  <DatePicker.NextTrigger
                    class="hover:bg-surface-indent inline-flex size-8 cursor-pointer items-center justify-center rounded-lg"
                  >
                    <Icon name="tabler:chevron-right" class="size-4" />
                  </DatePicker.NextTrigger>
                </DatePicker.ViewControl>

                <DatePicker.Table>
                  <DatePicker.TableBody>
                    <DatePicker.TableRow
                      v-for="(years, rowIndex) in datePicker.getYearsGrid({
                        columns: 4
                      })"
                      :key="rowIndex"
                    >
                      <DatePicker.TableCell
                        v-for="year in years"
                        :key="year.label"
                        :value="year.value"
                      >
                        <DatePicker.TableCellTrigger
                          class="text-body-3 hover:bg-surface-indent data-selected:bg-primary-default data-selected:text-on-primary w-full cursor-pointer rounded-lg px-3 py-2 text-center"
                        >
                          {{ year.label }}
                        </DatePicker.TableCellTrigger>
                      </DatePicker.TableCell>
                    </DatePicker.TableRow>
                  </DatePicker.TableBody>
                </DatePicker.Table>
              </DatePicker.Context>
            </DatePicker.View>
          </DatePicker.Content>
        </DatePicker.Positioner>
      </Teleport>
    </DatePicker.Root>

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
