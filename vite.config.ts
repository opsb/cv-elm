import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";

export default defineConfig({
  plugins: [elmPlugin()],
  base: "/",
  server: {
    host: true,
    // Same-origin proxy to the career-agent Worker (wrangler dev on :8787), so
    // the widget's relative "/agent/*" call works in dev exactly as it does
    // behind Caddy at cv.dev. Avoids mixed-content / CORS.
    proxy: {
      "/agent": {
        target: "http://localhost:8787",
        changeOrigin: true,
      },
    },
  },
});
