#!/bin/sh
# PromptLikeEngineer — Claude Code UserPromptSubmit hook.
#
# Prints at most one short "saved prompts that may fit" note, which Claude Code
# adds to Claude's context. Matching runs locally in `ple suggest --hook`
# (cached library or ~/.promptlike): no network, the message is not sent anywhere.
#
# This hook must never get in the way: every problem (no `ple`, suggestions
# off, any error) ends in a silent exit 0. `ple` enforces its own ~0.8 s budget;
# hooks.json's 2 s timeout is only a backstop.
#
# Turn off: /config → PromptLikeEngineer "Suggest saved prompts",
#           PLE_SUGGEST=off in your environment, or `ple config set suggest off`.

case "${PLE_SUGGEST:-on}" in off|OFF|false|0|no) exit 0 ;; esac
case "${CLAUDE_PLUGIN_OPTION_SUGGESTIONS:-true}" in false|0|off|no) exit 0 ;; esac

command -v ple >/dev/null 2>&1 || exit 0

ple suggest --hook 2>/dev/null
exit 0
