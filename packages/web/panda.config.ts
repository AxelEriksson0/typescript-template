import { defineConfig } from "@pandacss/dev"

export default defineConfig({
  exclude: [],
  include: ["./src/**/*.{js,jsx,ts,tsx}"],
  jsxFramework: "solid",
  outdir: "styled-system",
  preflight: true,
  presets: ["@pandacss/preset-base"],
  theme: { extend: {} },
})
