import tailwindcss from "@tailwindcss/vite"
import { defineConfig } from "vite"
import solidPlugin from "vite-plugin-solid"
import tsconfigPaths from "vite-tsconfig-paths"
// import devtools from 'solid-devtools/vite';

export default defineConfig({
  build: { target: "esnext", },
  plugins: [
    /*
    Uncomment the following line to enable solid-devtools.
    For more info see https://github.com/thetarnav/solid-devtools/tree/main/packages/extension#readme
    */
    // devtools(),
    solidPlugin(),
    tailwindcss(),
    tsconfigPaths({ root: "./" })
  ],
  server: { port: 5173, },
})
