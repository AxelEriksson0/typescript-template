import eslint from "@eslint/js"
import stylistic from "@stylistic/eslint-plugin"
import typescriptPlugin from "@typescript-eslint/eslint-plugin"
import typescriptParser from "@typescript-eslint/parser"
import { ESLint } from "eslint"
import { defineConfig, globalIgnores } from "eslint/config"
import simpleSortImport from "eslint-plugin-simple-import-sort"
import unusedImports from "eslint-plugin-unused-imports"
import globals from "globals"

export default defineConfig([
  globalIgnores([
    "**/dist/",
    "**/node_modules/",
    "**/paraglide/",
  ]),
  {
    ...eslint.configs.recommended,
    files: [
      "**/*.js",
      "**/*.ts",
      "**/*.tsx"
    ],
    languageOptions: {
      ecmaVersion: "latest",
      globals: { ...globals.browser, },
      parser: typescriptParser,
      parserOptions: {
        ecmaFeatures: { jsx: true },
        ecmaVersion: "latest",
        project: "./tsconfig.json",
      },
      sourceType: "module",
    },
    plugins: {
      "@stylistic": stylistic,
      "@typescript-eslint": typescriptPlugin as Record<string, ESLint.Plugin>,
      "simple-import-sort": simpleSortImport,
      "unused-imports": unusedImports
    },
    rules: {
      ...typescriptPlugin.configs["eslint-recommended"].rules,
      ...typescriptPlugin.configs["recommended"].rules,
      "@stylistic/arrow-spacing": "error",
      "@stylistic/block-spacing": "error",
      "@stylistic/brace-style": "error",
      "@stylistic/comma-spacing": "error",
      "@stylistic/eol-last": "error",
      "@stylistic/function-call-spacing": "error",
      "@stylistic/indent": ["error", 2],
      "@stylistic/jsx-first-prop-new-line": ["error", "multiline"],
      "@stylistic/jsx-max-props-per-line": "error",
      "@stylistic/jsx-self-closing-comp": "error",
      "@stylistic/jsx-sort-props": "error",
      "@stylistic/keyword-spacing": "error",
      "@stylistic/no-extra-parens": "error",
      "@stylistic/no-multi-spaces": "error",
      "@stylistic/no-multiple-empty-lines": ["error", { max: 2, maxBOF: 0, maxEOF: 0 }],
      "@stylistic/no-trailing-spaces": "error",
      "@stylistic/no-whitespace-before-property": "error",
      "@stylistic/object-curly-newline": [ "error", { "multiline": true }],
      "@stylistic/object-curly-spacing": ["error", "always"],
      "@stylistic/quotes": "error",
      "@stylistic/semi": ["error", "never"],
      "@stylistic/spaced-comment": "error",
      "@typescript-eslint/no-floating-promises": ["error",
        {
          allowForKnownSafeCalls: [
            { from: "package", name: ["suite", "test"], package: "node:test" },
          ],
        },
      ],
      "no-restricted-syntax": [
        "error",
        {
          message: "Don't focus tests",
          selector: "MemberExpression[object.name='describe'][property.name='only']",
        },
        {
          message: "Don't focus tests",
          selector: "MemberExpression[object.name='it'][property.name='only']",
        },
        {
          message: "Don't focus tests",
          selector: "MemberExpression[object.name='test'][property.name='only']",
        },
      ],
      "no-var": "error",
      "prefer-const": "error",
      "prefer-template": "error",
      "simple-import-sort/exports": "error",
      "simple-import-sort/imports": "error",
      "sort-keys": "error",
      "unused-imports/no-unused-imports": "error",
    },
  }
])
