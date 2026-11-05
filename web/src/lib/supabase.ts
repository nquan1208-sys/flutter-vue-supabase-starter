import { createClient } from '@supabase/supabase-js'
import { readConfig } from './config.ts'

const config = readConfig(import.meta.env, import.meta.env.MODE)
export const supabase = createClient(config.url, config.key)
