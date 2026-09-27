# promptlike — Claude Code plugin

Reach your [PromptLikeEngineer](https://promptlikeengineer.com) prompt library from inside
Claude Code. Your prompts stay versioned where you saved them; Claude pulls one by name at
the moment it needs it — no copy-paste, no stale duplicates in a system prompt.

## Install

From the community marketplace (once this plugin is listed there):

```bash
/plugin marketplace add anthropics/claude-plugins-community
```

Then install `promptlike` from `@claude-community`.

Or straight from this repo — works today, and useful for trying it before the
marketplace listing lands:

```bash
git clone https://github.com/zeynepaslierhann/promptlike-plugin
claude --plugin-dir ./promptlike-plugin
```

Sign in once so the server can read your library (it shares the CLI session):

```bash
npm i -g promptlike && ple login
```

Without signing in the plugin still loads and its tools are listed — each call
just answers "Not logged in. Run `ple login` first." instead of returning prompts.
The suggestion hook then uses your local prompts (`ple save`).

## What it adds

| Component | What it is |
|---|---|
| `promptlike` MCP server | Tools: `list_prompts`, `search_prompts`, `get_prompt`, `fill_variables`, `suggest_prompts` (read) · `save_prompt`, `update_prompt` (write — add only) |
| Your prompts as slash commands | Every saved prompt appears in the `/` menu as `/mcp__promptlike__<prompt-name>`; its `{{variables}}` become arguments. `/mcp__promptlike__save-this` saves the reusable prompt from the current conversation |
| Your prompts as `@` resources | `promptlike://<repo>/<prompt>` — attach a saved prompt with `@` |
| Suggestion hook | Before each message, a local match against your saved prompts; when one fits, Claude gets a one-line note (see below) |
| `/promptlike:prompt-library` skill | Teaches Claude to reach for a saved prompt instead of writing one from scratch, and to save good ones back |

Needs `promptlike-mcp` 0.4+ (the plugin pins `@0.4`).

## Saving from Claude Code

Ask Claude to save a prompt, or run `/mcp__promptlike__save-this`. Writes are **add-only**:
`save_prompt` creates a prompt, `update_prompt` adds a new version and keeps the old one.
Nothing is ever deleted, and saving the same thing twice changes nothing. Plan limits apply
exactly as on the web — when you hit one, Claude tells you and nothing is saved. Content
that looks like an API key or token is refused.

## Suggestion hook — what it does and how to turn it off

On every message you send, the plugin runs `ple suggest --hook` (a Claude Code
`UserPromptSubmit` hook). It:

- matches your message against your saved prompts **on this machine** — a cached copy of
  your library (or `~/.promptlike` when signed out). Your message is not sent anywhere;
- stays silent for slash commands, short messages (under 20 characters), weak matches, and
  prompts it already suggested in this session;
- otherwise adds one short note for Claude naming up to three prompts. Claude fetches one
  only if it is clearly relevant;
- needs the CLI (`npm i -g promptlike`); without it the hook does nothing. It never blocks
  your message: it answers in well under a second or stays silent.

Turn it off any of these ways:

- `/config` → PromptLikeEngineer → **Suggest saved prompts** → false
- `ple config set suggest off`
- `PLE_SUGGEST=off` in your environment (or in Claude Code's `settings.json` → `env`)

How often a suggestion is shown is counted on your machine only (`ple stats` shows it);
the server only learns when Claude actually fetches a suggested prompt.

## Self-hosting

Point at another deployment with `PROMPTLIKE_API_URL` (the same environment variable the
CLI honors).

## Links

- Product: https://promptlikeengineer.com
- MCP server on npm: https://www.npmjs.com/package/promptlike-mcp
- CLI on npm: https://www.npmjs.com/package/promptlike

MIT licensed.
