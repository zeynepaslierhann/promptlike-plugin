# promptlike — Claude Code plugin

Reach your [PromptLikeEngineer](https://promptlikeengineer.com) prompt library from inside
Claude Code. Your prompts stay versioned where you saved them; Claude pulls one by name at
the moment it needs it — no copy-paste, no stale duplicates in a system prompt.

## Install

From this repo's own marketplace — works today:

```bash
claude plugin marketplace add zeynepaslierhann/promptlike-plugin
claude plugin install promptlike@promptlikeengineer
```

Inside a Claude Code session the same two steps are
`/plugin marketplace add zeynepaslierhann/promptlike-plugin` and
`/plugin install promptlike@promptlikeengineer`.

From the community marketplace (once this plugin is listed there):

```bash
/plugin marketplace add anthropics/claude-plugins-community
```

Then install `promptlike` from `@claude-community`.

Or straight from a clone of this repo, handy for trying it without adding a
marketplace:

```bash
git clone https://github.com/zeynepaslierhann/promptlike-plugin
claude --plugin-dir ./promptlike-plugin
```

Sign in once so the server can read your library (it shares the CLI session):

```bash
npm i -g promptlike && ple login
```

Without signing in the plugin still loads and its tools are listed — each call
just answers "Not logged in. Run `ple login` in a terminal first (install: npm i -g promptlike)."
instead of returning prompts. The suggestion hook then uses your local prompts (`ple save`).

## What it adds

| Component | What it is |
|---|---|
| `promptlike` MCP server | Tools: `list_prompts`, `search_prompts`, `get_prompt`, `fill_variables`, `suggest_prompts` (read) · `save_prompt`, `update_prompt` (write — add only) |
| Your prompts as slash commands | Every saved prompt is an MCP prompt: type `/` and pick it, or run `/mcp__plugin_promptlike_promptlike__<prompt-name>` (a title such as "Code Review" becomes `code-review`). Its `{{variables}}` become arguments. `/mcp__plugin_promptlike_promptlike__save-this` saves the reusable prompt from the current conversation |
| Your prompts as `@` resources | `promptlike://<repo>/<prompt>` — attach a saved prompt with `@` |
| Suggestion hook | Before each message, a local match against your saved prompts; when one fits, Claude gets a short note (see below) |
| `/promptlike:prompt-library` skill | Teaches Claude to reach for a saved prompt instead of writing one from scratch, and to save good ones back |

The plugin starts the server with `npx -y promptlike-mcp@0.5.1`, pinned to that exact version.

## Examples

Each example starts with something you do. Swap in the names of prompts from your own library.

**1. Ask for a prompt by name.** You type:

```text
Run my code-review prompt on the changes in this branch.
```

Claude looks the prompt up (`get_prompt`, after a `search_prompts` if the name is not exact),
fills its `{{variables}}` with `fill_variables`, and follows the result. If the name matches
several prompts, Claude shows you the candidates instead of guessing.

**2. Run a prompt from the `/` menu.** You type:

```text
/mcp__plugin_promptlike_promptlike__code-review src/auth.ts security
```

The words after the command fill the prompt's `{{variables}}` in the order they first appear
in it (for a prompt that mentions `{{file}}` and then `{{focus}}`, the two words above). A
variable you leave out stays as `{{name}}` in the text Claude receives.

**3. Keep something you just worked out.** You type:

```text
/mcp__plugin_promptlike_promptlike__save-this
```

The prompt tells Claude to pull the reusable instruction out of the conversation, mark what
changes between uses as `{{variables}}`, show you the title, description and text, and then
call `save_prompt`. Saving is add-only, and text that looks like an API key or token is refused.

## Saving from Claude Code

Ask Claude to save a prompt, or run `/mcp__plugin_promptlike_promptlike__save-this`. Writes are
**add-only**: `save_prompt` creates a prompt, `update_prompt` adds a new version and keeps the
old one. Nothing is ever deleted, and saving the same thing twice changes nothing. Plan limits
apply exactly as on the web — when you hit one, Claude tells you and nothing is saved. Content
that looks like an API key or token is refused.

## Suggestion hook — what it does and how to turn it off

On every message you send, Claude Code runs `scripts/suggest.sh`, which runs
`ple suggest --hook` (a `UserPromptSubmit` hook). It:

- matches your message against your saved prompts **on this machine** — a local copy of
  your library (or `~/.promptlike` when signed out). Your message is not sent anywhere;
- stays silent for slash commands, short messages (under 20 characters), weak matches, and
  prompts it already suggested in this session;
- otherwise adds one short note for Claude naming up to three prompts. Claude fetches one
  only if it is clearly relevant;
- needs the CLI (`npm i -g promptlike`); without it the hook does nothing. It never blocks
  your message: it answers in well under a second or stays silent.

Turn it off any of these ways:

- `/config` → PromptLikeEngineer → **Suggest saved prompts** → false (or run
  `/plugin configure promptlike@promptlikeengineer`)
- `ple config set suggest off`
- `PLE_SUGGEST=off` in your environment (or in Claude Code's `settings.json` → `env`)

How often a suggestion is shown is counted on your machine only (`ple stats` shows it);
the server only learns when Claude actually fetches a suggested prompt.

## Data and privacy

This is everything the plugin runs and every place it talks to.

**Suggestion hook.** Before each message Claude Code runs `scripts/suggest.sh`, which runs
`ple suggest --hook` if the `ple` CLI is installed (otherwise nothing happens). Matching runs
on your machine. The hook does not send your message anywhere, makes no network request
itself and never waits for one. One thing does happen in the background: if you are signed in
and the local copy of your library is missing or more than 10 minutes old, the hook starts a
detached `ple suggest --refresh-cache` (at most once a minute) that downloads your own prompt
list from promptlikeengineer.com with your `ple login` session, so the next match uses a fresh
copy. Each of the three off switches above stops the hook, and that refresh with it. When a
prompt fits, Claude gets a two-line note naming up to three of your prompt titles; like any
text in your conversation, it is sent to the model with that turn.

**Files on your machine.** The CLI keeps these in `~/.config/promptlike/` (or the folder named
in `PROMPTLIKE_CONFIG_DIR`), created with owner-only permissions where the system supports
them: `config.json` (your session: tokens, email and user id, written by `ple login`),
`settings.json` (the on/off switch), `cache/library.json` (up to 500 prompts: title,
description, tags, repo, use count and the first 600 characters of the text) and
`cache/suggest-state.json` (a counter and the prompts suggested in your last 20 Claude Code
sessions). Signed out, the hook reads `~/.promptlike` instead.

**MCP server.** Claude Code starts it with `npx -y promptlike-mcp@0.5.1`; the first time, npm
downloads that exact version from the npm registry. It runs on your machine and talks only to
https://promptlikeengineer.com (or the address in `PROMPTLIKE_API_URL`, if you set one),
authenticating with the session `ple login` stored and refreshing it through the same host
when it expires. It has no other network code. What it sends:

- reads (`list_prompts`, `search_prompts`, `get_prompt`, `fill_variables`) ask your account
  for your prompts; Claude Code also asks for the list that fills the `/` menu and the `@`
  suggestions (up to 500 prompts, kept for 30 seconds);
- when Claude fetches a prompt — by tool, from the `/` menu or as an `@` resource — the server
  records a use event: which prompt and version, which of those three ways it was reached,
  whether it was offered as a suggestion, and the MCP client's name and version (for example
  `claude-code/2.1.179`);
- `suggest_prompts` sends the task description Claude gives it (up to 2,000 characters) so the
  server can match it against your library; the endpoint does not log or store that text. The
  hook above never does this;
- `save_prompt` and `update_prompt` send the text you asked to save.

**Limits on what it does.** Writes are add-only: the server has no delete tool, saving the same
text twice changes nothing, and content that looks like a secret (API keys, tokens, private
keys) is refused — the error names the kind, never the value. Prompts you save live in your
PromptLikeEngineer account; how the service handles them is in its
[Privacy Policy](https://promptlikeengineer.com/privacy) and
[Terms](https://promptlikeengineer.com/terms).

## Troubleshooting

| What you see | What to do |
|---|---|
| "Not logged in. Run `ple login` in a terminal first (install: npm i -g promptlike)." | Run `npm i -g promptlike && ple login` once, then ask again. Tools use the new session on the next call; slash commands and `@` resources are listed when the server connects, so start a new Claude Code session if they are missing |
| "Session expired. Run `ple login` in a terminal to sign in again." | Run `ple login` again |
| "Rate limited. Retry in 12s." | Wait that long, then ask again |
| "Cannot reach https://promptlikeengineer.com. Check your connection." or "No response from https://promptlikeengineer.com within 15s." | Check your connection and try again |
| "… Plan limit reached — nothing was saved. Upgrade: …" | Your plan's limit stopped the save and nothing changed |
| `claude mcp list` shows `plugin:promptlike:promptlike` as failed to connect | The server needs Node.js 18 or newer, `npx` on your PATH and, the first time, access to the npm registry. Run `npx -y promptlike-mcp@0.5.1` in a terminal: it prints `promptlike-mcp v0.5.0 ready (stdio).` when it starts (stop it with Ctrl-C), or the error if it cannot |
| No suggestion notes appear | The hook needs the `ple` CLI on your PATH. It stays silent for slash commands, messages under 20 characters, weak matches and prompts already suggested in this session, and when it is switched off: `ple config get suggest` shows whether it is on |

## Self-hosting

Point at another deployment with `PROMPTLIKE_API_URL` (the same environment variable the
CLI honors).

## Support and security

Questions and bug reports: open an issue at
https://github.com/zeynepaslierhann/promptlike-plugin/issues or write to Zeynep Aslı Erhan ·
zeynepaslierhan@gmail.com. Please report a security problem by email rather than in a public
issue. This repository holds only the plugin files; the MCP server is the npm package
[`promptlike-mcp`](https://www.npmjs.com/package/promptlike-mcp) and the CLI you sign in with
is [`promptlike`](https://www.npmjs.com/package/promptlike), both MIT licensed.

## Links

- Product: https://promptlikeengineer.com/?utm_source=github&utm_medium=readme&utm_campaign=ple_dist
- Documentation: https://promptlikeengineer.com/docs/mcp
- Privacy Policy: https://promptlikeengineer.com/privacy · Terms: https://promptlikeengineer.com/terms
- MCP server on npm: https://www.npmjs.com/package/promptlike-mcp
- CLI on npm: https://www.npmjs.com/package/promptlike

MIT licensed.
