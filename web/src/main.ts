import { createApp } from 'vue'
import ui from '@nuxt/ui/vue-plugin'
import App from './App.vue'
import { supabase } from './lib/supabase.ts'
import './style.css'

// Validate and initialize the shared client before rendering the application.
void supabase
createApp(App).use(ui).mount('#app')
