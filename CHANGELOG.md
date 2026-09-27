# Changelog

## 0.3.0 — unreleased (2026-09-27)

Save from the agent, and a nudge when a saved prompt fits.

- **Save from Claude Code** (`promptlike-mcp` 0.4.0): `save_prompt` and `update_prompt`
  tools, plus the `/mcp__promptlike__save-this` prompt. Add-only: a new prompt or a new
  version, never a delete. Idempotent, plan limits apply, secrets are refused.
- **Prompts as `@` resources:** `promptlike://<repo>/<prompt>`.
- **Suggestion hook** (`hooks/hooks.json` → `scripts/suggest.sh` → `ple suggest --hook`):
  local match on every message, no network, silent unless something fits. Off via the new
  plugin option `suggestions`, `PLE_SUGGEST=off`, or `ple config set suggest off`.
  Needs `promptlike` CLI 0.6.0+.
- `suggest_prompts` tool for agents without hooks (server-side match on your own library).
- `.mcp.json` pins `promptlike-mcp@0.4`.

**Release order (do not skip):**

1. Publish `promptlike-mcp@0.4.0` and `promptlike@0.6.0` to npm (tag push).
2. Only then sync this folder to github.com/zeynepaslierhann/promptlike-plugin —
   `npx -y promptlike-mcp@0.4` fails until 0.4.0 is on npm, which would leave the plugin
   with no server.

## 0.2.0 — not released on its own (folded into 0.3.0)

- Your saved prompts show up as slash commands (`/mcp__promptlike__<name>`),
  with `{{variables}}` as arguments. Comes from `promptlike-mcp` 0.3.0, which
  implements the MCP `prompts` primitive.

**Release order (do not skip):**

1. Publish `promptlike-mcp@0.3.0` to npm.
2. Then change `.mcp.json` from `promptlike-mcp@0.2` to `promptlike-mcp@0.3`.
3. Then sync this folder to github.com/zeynepaslierhann/promptlike-plugin.

`.mcp.json` stays on `@0.2` until step 1 is done: `npx -y promptlike-mcp@0.3`
fails while 0.3.0 is not on npm, which would leave the plugin with no server.

## 0.1.0

- `promptlike` MCP server (four read-only tools) + `prompt-library` skill.
