/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
    theme: {
        extend: {
            colors: {
                primary: {
                    DEFAULT: "#0d1623",
                    light: "#212b39",
                },
                background: {
                    DEFAULT: "#0d1623",
                    end: "#1B2D47"
                },
                secondary: "#6eb0e6",
                faded: "#707c8e",
            },
        },
    },
    plugins: [],
}
