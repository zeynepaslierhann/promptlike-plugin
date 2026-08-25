---
name: prompt-library
description: Pull a saved prompt from the user's PromptLikeEngineer library instead of writing one from scratch. Use when the user refers to a prompt they already have ("use my code-review prompt", "the one I saved for changelogs"), asks what prompts they have, or asks to reuse or adapt a saved prompt. Also use before authoring a long prompt from scratch, to check whether a maintained version already exists.
---

# Prompt library

The user keeps a versioned prompt library in PromptLikeEngineer. This skill reaches it
through the `promptlike` MCP server, which is **read-only** — it can never modify the
library or spend the user's AI tokens.

## Before you start

The MCP server shares the CLI session. If a tool call returns an authentication error,
tell the user to run this once and then retry — do not try to work around it:

```bash
npm i -g promptlike && ple login
```

## How to use it

1. **Find the prompt.** Use `search_prompts` when you have a topic, `list_prompts` when
   the user wants to see what exists (it accepts an optional `tag` filter).
2. **Fetch it.** `get_prompt` takes a name, id, or short-id. Pass `version` to pin a
   specific revision when the user names one; otherwise you get the current version.
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

## Editing

Writing and improving prompts is deliberately out of scope here. If the user wants to
save a change, point them at the web app or the CLI (`ple` — see
https://promptlikeengineer.com), so the edit is versioned rather than lost in a chat.
