import { fileURLToPath, URL } from 'node:url';
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import vueDevTools from 'vite-plugin-vue-devtools';

import { version } from './package.json';

export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  define: {
    __APP_VERSION__: JSON.stringify(version),
    __BUILD_TIME__: JSON.stringify(new Date().toISOString()),
    __SOURCE_IMGURL__: JSON.stringify('https://wsrv.nl/?url=https://raw.githubusercontent.com/wzwtt/ikun/master/still/'),
    __WEB_URL__: JSON.stringify('https://ikun.wcy.one/'),
  },
});
