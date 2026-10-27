# Changelog

## 0.4.1 — 2026-10-25

The MCP server is now pinned to `promptlike-mcp@0.5.1`: the client refuses plain-http API URLs and never follows redirects (a redirect can no longer replay your login), writes the saved session atomically with owner-only permissions, and its secret check also covers changelog text and tags and ignores invisible characters. Nothing else in the plugin changed.

## 0.4.0 — 2026-10-22

Install from this repository as its own Claude Code marketplace, the MCP server is pinned to
an exact version, and the manifest and README carry what Anthropic's plugin directory reads
for a listing. What the suggestion hook does is unchanged; only its description is more exact.

- **Own marketplace:** new `.claude-plugin/marketplace.json` makes this repository addable as
  a Claude Code marketplace: `claude plugin marketplace add zeynepaslierhann/promptlike-plugin`,
  then `claude plugin install promptlike@promptlikeengineer`. 0.3.0 had no marketplace file,
  so that command could not work. The listing says writes are add-only.
- **MCP server pinned exactly:** `.mcp.json` now starts `promptlike-mcp@0.5.0` (was the range
  `@0.4`). Anthropic's plugin directory blocks an `npx` launcher that is not pinned to an exact
  version, so from now on each `promptlike-mcp` release needs a plugin release: publish the
  server to npm first, then change the pin, raise `version` here and sync this repository.
  New in `promptlike-mcp` 0.5.0 (details in its changelog):
  - `label` on `get_prompt` and `fill_variables` reads the version a deployment label (for
    example `production`) points at instead of the current one; `version` and `label`
    together are rejected.
  - `fill_variables` understands `{{#if var}}…{{else}}…{{/if}}` and
    `{{#unless var}}…{{/unless}}` (text only; nesting limited to 5 levels).
- **Manifest:** `plugin.json` adds `author.email` and the directory-listing fields `icon`
  (`./logo.png`, a new file), `documentationUrl`, `supportUrl`, `privacyPolicyUrl` and
  `termsOfServiceUrl`. Claude Code ignores those five when it loads the plugin; the directory
  reads them for the listing. `claude plugin validate` before Claude Code v2.1.281 reports
  each as an unknown field: a warning, which `--strict` turns into a failure.
- **README:** new sections Examples, Data and privacy (everything the plugin runs and every
  place it talks to), Troubleshooting, and Support and security; the install section leads
  with the marketplace path and keeps the clone + `--plugin-dir` route for trying the plugin
  without adding a marketplace; the note on the pinned server names `0.5.0`; the signed-out
  message it quotes now matches what the MCP server actually returns; the product link
  carries UTM parameters.
- **Fixed: slash-command name.** A plugin's MCP server is named `plugin:promptlike:promptlike`,
  so its prompts run as `/mcp__plugin_promptlike_promptlike__<name>` (for example
  `/mcp__plugin_promptlike_promptlike__save-this`). The README and the skill said
  `/mcp__promptlike__<name>`, which is the name only when the server is added by hand.
- **Hook description, exact:** the hook option and `hooks.json` said "no network". Matching
  runs on your machine and your message never leaves it, but when you are signed in `ple` can
  refresh its cached copy of your own library in the background (at most once a minute; the
  hook never waits for it). The texts now say "your message never leaves this machine".
- **Skill:** says where instructions come from: when Claude follows a saved prompt it names
  it (title and version), and it only reads prompts you saved.

## 0.3.0 — 2026-09-27

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
