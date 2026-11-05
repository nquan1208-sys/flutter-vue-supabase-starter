import assert from 'node:assert/strict'
import { test } from 'node:test'
import { readConfig } from '../src/lib/config.ts'

const valid = {
  VITE_SUPABASE_URL: 'https://example.supabase.co',
  VITE_SUPABASE_PUBLISHABLE_KEY: 'sb_publishable_test',
}

test('each mode accepts public client settings', () => {
  for (const mode of ['localdev', 'development', 'production']) {
    assert.deepEqual(readConfig(valid, mode), { url: valid.VITE_SUPABASE_URL, key: valid.VITE_SUPABASE_PUBLISHABLE_KEY })
  }
})

test('HTTP is local-only', () => {
  const env = { ...valid, VITE_SUPABASE_URL: 'http://127.0.0.1:55321' }
  assert.equal(readConfig(env, 'localdev').url, env.VITE_SUPABASE_URL)
  for (const mode of ['development', 'production']) assert.throws(() => readConfig(env, mode))
})

test('rejects missing settings, unsafe URLs, and private keys', () => {
  assert.throws(() => readConfig({}, 'localdev'))
  for (const url of ['', 'invalid', 'ftp://example.com', 'https://user:password@example.com', 'https://example.com?token=x', 'https://example.com#fragment']) {
    assert.throws(() => readConfig({ ...valid, VITE_SUPABASE_URL: url }, 'localdev'))
  }
  for (const key of ['', 'sb_secret_test', 'sb_publishable_', 'eyJlegacy']) {
    assert.throws(() => readConfig({ ...valid, VITE_SUPABASE_PUBLISHABLE_KEY: key }, 'localdev'))
  }
})
