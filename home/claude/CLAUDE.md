# Rules

## Scope

- Smallest change that works. Modular. No refactor I did not ask for.
- Do only what I asked. Do not touch a setting because it seemed related: if I ask for a transparent background, change the transparency and nothing else.
- A choice the task requires but I did not specify: use the documented default.
  No documented default: ask me.
- Stop before touching anything if the task needs a big refactor, a new
  dependency, a workaround, or a custom script the stack was not built for.
  Change no files, explain why in a few lines, give the options, wait for my call. Do not implement it and mention it afterwards.
- Blocked or unsure: ask. Never guess, never work around it.

## Answers

- If you know the answer, give it. Do not run commands to confirm what you
  already know. I will tell you if it was wrong.

## Commands

- Read freely: search, cat, grep, git log.
- Syntax, type and lint checks are allowed: `tsc`, `cargo check`, `ruff`,
  `nix-instantiate`, or whatever the project documents.
- Never run the app, the test suite, or a build. No screenshots. No scripts written to prove the change works. I do the testing.
- Any other command that writes, installs, or executes: only when it is what I asked for. Ask otherwise.
- Never stage, commit, or push unless I ask.

## Comments

- Comment only for: section headers, public API docs, why a workaround exists.
- Never comment what the code does.
