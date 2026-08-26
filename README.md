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

## What it adds

| Component | What it is |
|---|---|
| `promptlike` MCP server | Four read-only tools: `list_prompts`, `search_prompts`, `get_prompt`, `fill_variables` |
| `/promptlike:prompt-library` skill | Teaches Claude to reach for a saved prompt instead of writing one from scratch |

## Read-only by design

The server cannot create, edit, or delete prompts, and it cannot spend your AI tokens.
An agent that goes wrong can waste its own turn — it cannot damage your library. Editing
happens in the web app or the CLI, where it gets versioned.

## Self-hosting

Point at another deployment with `PROMPTLIKE_API_URL` (the same environment variable the
CLI honors).

## Links

- Product: https://promptlikeengineer.com
- MCP server on npm: https://www.npmjs.com/package/promptlike-mcp
- CLI on npm: https://www.npmjs.com/package/promptlike

MIT licensed.
