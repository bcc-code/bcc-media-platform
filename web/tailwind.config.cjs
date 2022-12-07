/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
    theme: {
        extend: {
            colors: {
                primary: {
                    DEFAULT: "#6eb0e6",
                    hover: "#6dafe5",
                    light: "#1D2838",
                },
                background: {
                    DEFAULT: "#0d1623",
                },
                gray: "#707c8e",
                green: {
                    DEFAULT: "#71D2A4",
                    hover: "#70D1A3",
                },
                red: {
                    DEFAULT: "#E63C62",
                    hover: "#E53B61",
                },
                secondary: {
                    DEFAULT: "#202a39",
                    hover: "#192938",
                },
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
                "dark-transparent": "var(--color-dark-transparent)"
            },
        },
    },
    plugins: [require("@tailwindcss/line-clamp")],

}
