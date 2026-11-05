export function readConfig(env: Record<string, string | undefined>, mode: string) {
  const url = env.VITE_SUPABASE_URL?.trim() ?? ''
  const key = env.VITE_SUPABASE_PUBLISHABLE_KEY?.trim() ?? ''
  let parsed: URL
  try {
    parsed = new URL(url)
  } catch {
    throw new Error('VITE_SUPABASE_URL must be an HTTP(S) URL with a host.')
  }
  if (!['http:', 'https:'].includes(parsed.protocol) || !parsed.hostname ||
      parsed.username || parsed.password || parsed.search || parsed.hash ||
      (mode !== 'localdev' && parsed.protocol !== 'https:')) {
    throw new Error('VITE_SUPABASE_URL must be a plain backend URL; development and production require HTTPS.')
  }
  if (!key.startsWith('sb_publishable_') || key.length <= 'sb_publishable_'.length) {
    throw new Error('VITE_SUPABASE_PUBLISHABLE_KEY must be a publishable key.')
  }
  return { url, key }
}
