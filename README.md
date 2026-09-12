# claude-commands

Praveen's Claude Code slash commands (`~/.claude/commands/`).

## Validation

Every command file (`*.md`) must have YAML frontmatter with `description`,
`argument-hint`, and `allowed-tools`, and balanced code fences. One script
enforces this everywhere:

```bash
scripts/validate.sh
```

- **Git pre-commit**: `scripts/hooks/pre-commit` runs it before each commit.
  Enabled locally via `git config core.hooksPath scripts/hooks` (already set
  on this machine; re-run that command after a fresh clone).
- **CI**: `.github/workflows/validate.yml` runs it on every push/PR.
- **Claude Code hook**: `.claude/settings.json` runs it after any Write/Edit
  in this repo, so a command file is checked the moment it's saved, not just
  at commit time.

## Convention for new commands/skills

This repo's structure (frontmatter + validate script + git hook + CI +
Claude Code hook, all calling the same check) is the standard pattern for
new slash commands and skills going forward — see
`~/.claude/memory/claude-commands-build-process.md`.
