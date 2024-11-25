
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap/dist/js/bootstrap.bundle';
// main.js 또는 main.ts (Vue.js의 진입 파일)
import 'bootstrap-icons/font/bootstrap-icons.css';



import App from './App.vue'
import router from './router'
import { useKakao } from 'vue3-kakao-maps';

useKakao('cd5a1c790450a789a3b6be41b3f5932f');

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
