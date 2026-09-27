---
name: prompt-library
description: Pull a saved prompt from the user's PromptLikeEngineer library instead of writing one from scratch, and save good prompts back to it. Use when the user refers to a prompt they already have ("use my code-review prompt", "the one I saved for changelogs"), asks what prompts they have, asks to reuse or adapt a saved prompt, or asks to save/keep a prompt from this conversation. Also use before authoring a long prompt from scratch, to check whether a maintained version already exists.
---

# Prompt library

The user keeps a versioned prompt library in PromptLikeEngineer. This skill reaches it
through the `promptlike` MCP server. It reads freely; it writes only by **adding** — a new
prompt or a new version — and never deletes anything or spends the user's AI tokens.

## Before you start

The MCP server shares the CLI session. If a tool call returns an authentication error,
tell the user to run this once and then retry — do not try to work around it:

```bash
npm i -g promptlike && ple login
```

## How to use it

1. **Find the prompt.** Use `search_prompts` when you have a topic, `list_prompts` when
   the user wants to see what exists (it accepts an optional `tag` filter). At the start of
   a non-trivial task, `suggest_prompts` with a one-line task summary checks whether a
   saved prompt fits.
2. **Fetch it.** `get_prompt` takes a name, id, or short-id. Pass `version` to pin a
   specific revision when the user names one; otherwise you get the current version.
   When you fetch a prompt because `suggest_prompts` or a "PromptLikeEngineer: … may fit"
   note offered it, pass `via: "suggestion"`.
3. **Fill placeholders.** If the prompt contains `{{variables}}`, prefer `fill_variables`
   over substituting by hand — it returns ready-to-use text and reports anything it could
   not fill in `missing_variables`.

## Rules

- **Do not invent a prompt when one exists.** The point of the library is that the saved
  version is the maintained one.
- **Ambiguous name → ask.** The server returns a candidate list (id + title) rather than
  guessing. Show the user the candidates instead of picking one yourself.
- **Do not paste the whole library into context.** Fetch the one prompt you need.
- **Report unfilled variables.** If `missing_variables` is non-empty, ask the user for
  those values before running the prompt.
- **Rate limits** surface as `Retry in Ns`. Wait that long rather than retrying immediately.

## Saving

- **New prompt:** `save_prompt` with `title`, `content`, and optionally `description`,
  `project` (repo) and `tags`. Mark the parts that change between uses as
  `{{snake_case}}` variables. The `/mcp__promptlike__save-this` prompt walks through
  extracting a reusable prompt from the conversation.
- **New version of an existing prompt:** `update_prompt` with the **exact** title or id and
  the full new `content` (plus `changelog`, and `bump` if the user asks for minor/major).
  The old version is kept.
- Only save when the user asks you to. Show them what you are saving first.
- Never put secrets (API keys, tokens, passwords) in a prompt — the server refuses content
  that looks like one; replace the value with a `{{variable}}`.
- Saving the same title and content twice changes nothing. If the title exists with
  different content, `save_prompt` says so — ask the user whether to `update_prompt`.
- A plan-limit answer means nothing was saved. Relay the message (it has the upgrade link)
  instead of retrying.
