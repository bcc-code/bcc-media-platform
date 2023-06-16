const plugin = require("tailwindcss/plugin")

/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
    theme: {
        extend: {
            fontFamily: {
                archivo: ["Archivo", "sans-serif"],
            },
            colors: {
                primary: {
                    DEFAULT: "#6eb0e6",
                    hover: "#6dafe5cc",
                    light: "#1D2838",
                },
                background: {
                    DEFAULT: "#0d1623",
                },
                gray: "#707c8e",
                green: {
                    DEFAULT: "#71D2A4",
                    hover: "#71D2A4cc",
                },
                red: {
                    DEFAULT: "#E63C62",
                    hover: "#E63C62cc",
                },
                secondary: {
                    DEFAULT: "#202a39",
                    hover: "#202a39cc",
                },
                bcc: {
                    DEFAULT: "#004e48",
                    1: "#1e1e1e",
                    2: "#012625",
                    3: "#dbe1c0",
                },
                // from figma:
                "tint-1": "var(--color-tint-1)",
                "tint-2": "var(--color-tint-2)",
                "tint-3": "var(--color-tint-3)",
                "on-tint": "var(--color-on-tint)",
                "label-1": "var(--color-label-1)",
                "label-2": "var(--color-label-2)",
                "label-3": "var(--color-label-3)",
                "label-4": "var(--color-label-4)",
                "background-1": "var(--color-background-1)",
                "background-2": "var(--color-background-2)",
                "separator-on-light": "var(--color-separator-on-light)",
                "light-1": "var(--color-light-1)",
                "dark-transparent": "var(--color-dark-transparent)",
            },
        },
    },
    plugins: [
        plugin(function ({ addVariant, e }) {
            addVariant("embed", ({ modifySelectors, separator }) => {
                modifySelectors(({ className }) => {
                    return `.embedded-page .${e(
                        `embed${separator}${className}`
                    )}`
                })
            })
        }),
        require("@tailwindcss/typography"),
    ],
}
