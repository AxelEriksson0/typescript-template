import { defineConfig } from "@pandacss/dev"

export default defineConfig({
  exclude: [],
  // Where to look for your css declarations
  include: ["./src/**/*.{js,jsx,ts,tsx}", "./pages/**/*.{js,jsx,ts,tsx}"],
  // Whether to use css reset
  // The output directory for your css system
  outdir: "styled-system",
  preflight: true,
  // Useful for theme customization
  theme: { extend: {}, },
})
