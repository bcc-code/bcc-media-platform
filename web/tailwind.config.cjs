/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
    theme: {
        extend: {
            colors: {
                primary: {
                    DEFAULT: "#6eb0e6",
                    hover: "#6dafe5",
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
            },
        },
    },
    plugins: [],
}
