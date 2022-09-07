module.exports = {
    extends: ["plugin:vue/recommended", "plugin:prettier-vue/recommended"],

    settings: {
        "prettier-vue": {
            // Settings for how to process Vue SFC Blocks
            SFCBlocks: {
                template: true,
                script: true,
                style: true,

                customBlocks: {
                    docs: { lang: "markdown" },
                    config: { lang: "json" },
                    module: { lang: "ts" },
                    comments: false,
                },
            },
            usePrettierrc: true,
            fileInfoOptions: {
                ignorePath: ".testignore",
                withNodeModules: false,
            },
        },
    },

    rules: {
        "prettier-vue/prettier": [
            "error",
            {
                printWidth: 100,
                singleQuote: true,
                semi: false,
                trailingComma: "es5",
            },
        ],
    },
}
