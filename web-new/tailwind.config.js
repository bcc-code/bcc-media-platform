/** @type {import('tailwindcss').Config} */
export default {
	content: ['**/*.{vue,js,ts}'],
	theme: {
		extend: {
			fontFamily: {
				archivo: ['Archivo', 'sans-serif'],
			},
			colors: {
				primary: {
					DEFAULT: '#6eb0e6',
					hover: '#6dafe5cc',
					light: '#1D2838',
				},
				background: {
					DEFAULT: '#0d1623',
				},
				gray: '#707c8e',
				green: {
					DEFAULT: '#71D2A4',
					hover: '#71D2A4cc',
				},
				red: {
					DEFAULT: '#E63C62',
					hover: '#E63C62cc',
				},
				secondary: {
					DEFAULT: '#202a39',
					hover: '#202a39cc',
				},
				bcc: {
					DEFAULT: '#004e48',
					1: '#1e1e1e',
					2: '#012625',
					3: '#dbe1c0',
				},
				// from figma:
				'tint-1': 'rgb(var(--color-tint-1) / <alpha-value>)',
				'tint-2': 'rgb(var(--color-tint-2) / <alpha-value>)',
				'tint-3': 'rgb(var(--color-tint-3) / <alpha-value>)',
				'on-tint': 'rgb(var(--color-on-tint) / <alpha-value>)',
				'label-1': 'rgb(var(--color-label-1) / <alpha-value>)',
				'label-2': 'rgb(var(--color-label-2) / <alpha-value>)',
				'label-3': 'rgb(var(--color-label-3) / <alpha-value>)',
				'label-4': 'rgb(var(--color-label-4) / <alpha-value>)',
				'background-1':
					'rgb(var(--color-background-1) / <alpha-value>)',
				'background-2':
					'rgb(var(--color-background-2) / <alpha-value>)',
				'separator-on-light': 'var(--color-separator-on-light)',
				'light-1': 'rgb(var(--color-light-1) / <alpha-value>)',
				'dark-transparent': 'var(--color-dark-transparent)',
			},
			transitionTimingFunction: {
				'out-expo': 'cubic-bezier(0.16, 1, 0.3, 1)',
			},
		},
	},
	plugins: [
		function ({ addVariant, e }) {
			addVariant('embed', ({ modifySelectors, separator }) => {
				modifySelectors(({ className }) => {
					return `.embedded-page .${e(
						`embed${separator}${className}`
					)}`
				})
			})
		},
		function ({ addComponents }) {
			addComponents({
				'.text-style-headline-1': {
					'font-size': '2.125rem',
					'font-family': '"Barlow"',
					'font-weight': '800',
					'font-style': 'normal',
					'line-height': '40px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-headline-2': {
					'font-size': '1.75rem',
					'font-family': '"Barlow"',
					'font-weight': '800',
					'font-style': 'normal',
					'line-height': '32px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-title-1': {
					'font-size': '1.5rem',
					'font-family': '"Barlow"',
					'font-weight': '800',
					'font-style': 'normal',
					'line-height': '28px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-title-2': {
					'font-size': '1.25rem',
					'font-family': '"Barlow"',
					'font-weight': '700',
					'font-style': 'normal',
					'line-height': '24px',
					'letter-spacing': '-0.3px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-title-3': {
					'font-size': '1.062rem',
					'font-family': '"Barlow"',
					'font-weight': '700',
					'font-style': 'normal',
					'line-height': '20px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-body-1': {
					'font-size': '1.188rem',
					'font-family': '"Barlow"',
					'font-weight': '400',
					'font-style': 'normal',
					'line-height': '24px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-body-2': {
					'font-size': '1rem',
					'font-family': '"Barlow"',
					'font-weight': '500',
					'font-style': 'normal',
					'line-height': '20px',
					'font-spacing': '0px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-button-1': {
					'font-size': '1.125rem',
					'font-family': '"Barlow"',
					'font-weight': '700',
					'font-style': 'normal',
					'line-height': '24px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-button-2': {
					'font-size': '0.938rem',
					'font-family': '"Barlow"',
					'font-weight': '700',
					'font-style': 'normal',
					'line-height': '24px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-button-2-upper': {
					'font-size': '0.938rem',
					'font-family': '"Barlow"',
					'font-weight': '700',
					'font-style': 'normal',
					'line-height': '24px',
					'text-decoration': 'none',
					'text-transform': 'uppercase',
				},
				'.text-style-caption-1': {
					'font-size': '0.875rem',
					'font-family': '"Barlow"',
					'font-weight': '500',
					'font-style': 'normal',
					'line-height': '16px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-caption-2': {
					'font-size': '0.75rem',
					'font-family': '"Barlow"',
					'font-weight': '500',
					'font-style': 'normal',
					'line-height': '14px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-caption-3': {
					'font-size': '0.688rem',
					'font-family': '"Barlow"',
					'font-weight': '500',
					'font-style': 'normal',
					'line-height': '12px',
					'letter-spacing': '-0.27px',
					'text-decoration': 'none',
					'text-transform': 'none',
				},
				'.text-style-overline': {
					'font-size': '0.938rem',
					'font-family': '"Barlow"',
					'font-weight': '600',
					'font-style': 'normal',
					'line-height': '20px',
					'letter-spacing': '1px',
					'text-decoration': 'none',
					'text-transform': 'uppercase',
				},
			})
		},
	],
}