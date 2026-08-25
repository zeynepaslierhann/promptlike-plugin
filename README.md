# promptlike — Claude Code plugin

Reach your [PromptLikeEngineer](https://promptlikeengineer.com) prompt library from inside
Claude Code. Your prompts stay versioned where you saved them; Claude pulls one by name at
the moment it needs it — no copy-paste, no stale duplicates in a system prompt.

## Install

```bash
/plugin marketplace add anthropics/claude-plugins-community
```

Then install `promptlike` from `@claude-community`.

Sign in once so the server can read your library (it shares the CLI session):

```bash
npm i -g promptlike && ple login
```

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
