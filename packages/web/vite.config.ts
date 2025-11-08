import { defineConfig } from "vite"
import { paraglideVitePlugin } from "@inlang/paraglide-js"
import solidPlugin from "vite-plugin-solid"
import tailwindcss from "@tailwindcss/vite"
import tsconfigPaths from "vite-tsconfig-paths"
// import devtools from 'solid-devtools/vite';

export default defineConfig({
  build: { target: "esnext" },
  plugins: [
    /*
    Uncomment the following line to enable solid-devtools.
    For more info see https://github.com/thetarnav/solid-devtools/tree/main/packages/extension#readme
    */
    // devtools(),
    paraglideVitePlugin({
      outdir: "./src/paraglide",
      project: "./project.inlang",
      strategy: ["url"],
      urlPatterns: [
        {
          localized: [
            ["en", "/en/:path(.*)?"],
            // ✅ make sure to match the least specific path last
            ["sv", "/:path(.*)?"],
          ],
          pattern: "/:path(.*)?",
        },
      ],
    }),
    solidPlugin(),
    tailwindcss(),
    tsconfigPaths({ root: "./" }),
  ],
  server: { port: 5173 },
})
