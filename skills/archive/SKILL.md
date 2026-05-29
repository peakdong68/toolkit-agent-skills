---
name: archive
description: 'Use when archiving completed features, moving finished work to docs/archive/, updating the global spec index, or running /archive command. Triggers on feature completion, sprint wrap-up, cleanup of stale spec/plan directories, or any request to "archive" completed work.'
---

# Archive Completed Features

## Overview

Archive completed feature directories from `docs/changes/` to `docs/archive/`, moving them as a whole while preserving the complete subdirectory structure. Verifies task completion via git history — not code analysis. This skill differs from `code-review`: it checks document checkboxes and git log to confirm what was done, never inspecting source code. Every archive run updates the global spec index at `docs/global/index.md`.

**Announce at start:** "I'm using the archive skill to archive completed features."

---

## Phase 1: Discover Completed Features

**Goal:** Identify candidate feature directories whose tasks are fully checked off.

### Actions

1. Use Glob to match all feature directories under `docs/changes/`:

   ```
   Glob: docs/changes/*/
   ```

   Directory naming format: `<date>_<topic>` (e.g., `2026-05-10_color-extraction`).

2. For each feature directory, check task completion status:
   - Read `plan.md` and inspect `[x]` / `[ ]` checkbox states
   - Identify directories where ALL tasks are marked `[x]`

3. If the directory contains `prd.md` (PRDs have no checkboxes), determine completion via git history:
   - Check for commits referencing the feature name or corresponding topic

4. Cross-reference with git history:

```bash
git log --oneline -20          # recent commits
git diff --stat HEAD~N..HEAD   # files changed in recent work
```

Match commit messages to task descriptions to confirm completion is genuine (not just checkboxes ticked).

### Decision Table: Completion Confidence

| Sign                                  | Confidence | Action                                 |
| ------------------------------------- | ---------- | -------------------------------------- |
| All `[x]` + matching git commits      | High       | Proceed to archive                     |
| All `[x]` but no matching git history | Low        | Flag for manual review, do NOT archive |
| Mixed `[ ]` still open                | Incomplete | Skip — feature is not done             |
| No plan.md found                      | Unknown    | Skip — no checklist to verify          |

### STOP — Do NOT proceed to Phase 2 until:

- [ ] Candidate feature directories are identified
- [ ] Git history confirms task completion for each candidate
- [ ] Low-confidence features are flagged for manual review

---

## Phase 2: Confirm with User

**Goal:** Present the archive candidates and get explicit approval before moving files.

### Actions

1. List candidates with completion evidence:

```
| Feature Directory                                     | Tasks Done | Git Commits | Confidence |
| ----------------------------------------------------- | ---------- | ----------- | ---------- |
| docs/changes/2026-05-10_login/plan.md                        | 5/5 [x]    | 3 matching  | High       |
```

2. Ask ONE clear question: "Archive these completed features?"

**STOP — Do NOT proceed to Phase 3 until user explicitly approves.**

---

## Phase 3: Execute Archive

**Goal:** Move completed feature directories as a whole to `docs/archive/` and clean up.

### Actions

1. Ensure `docs/archive/` exists:

   ```bash
   mkdir -p docs/archive
   ```

2. Move the entire feature directory into the archive:

   ```bash
   mv docs/changes/<date>_<topic> docs/archive/
   ```

   All artifacts within the directory (`plan.md`, `design.md`, `intent.md`, `prd.md`, `specs/`, etc.) are archived together in a single move — structure remains intact.

3. Verify archive content integrity — use Glob to confirm the directory structure:

   ```
   Glob: docs/archive/<date>_<topic>/
   Glob: docs/archive/<date>_<topic>/**/*
   ```

   Expected contents: `plan.md` `design.md` `intent.md` `prd.md` `specs/*.md`

4. **Fix relative path references** in archived documents — scan all `.md` files in `docs/archive/<date>_<topic>/` for internal relative links. Archived paths change from `../../changes/` to `../../archive/`; sibling directory relative paths remain valid. Update paths pointing to resources still in `docs/changes/` (not yet archived).

5. Confirm original location is clean — use folder_operations to check if the directory still exists:
   ```
   folder_operations: exists docs/changes/<date>_<topic>
   ```
   Non-existence confirms cleanup.

### STOP — Do NOT proceed to Phase 4 until:

- [ ] All confirmed directories are moved to `docs/archive/`
- [ ] Relative path references in archived documents are checked and fixed
- [ ] Original location is clean (`docs/changes/<date>_<topic>` no longer exists)
- [ ] Archived directory contains all expected files

---

## Phase 4: Update Global Spec Index

**Goal:** Update `docs/global/index.md` to reflect the archive operation.

### Actions

1. Read `docs/global/index.md` — if it does not exist, create it with the template below.

2. **Append archive row to `## Completed Features` table** — insert at the top:

```
| [<directory-name>](../archive/2026-05-10_color-extraction/plan.md) | <one-line summary> | <domain> | <today-ISO-date> |
```

- **Summary:** Extract from `design.md` title/overview or `plan.md` goal field — one sentence max.
- **Domain:** Infer from feature topic segment (e.g., `2026-05-10-tool-search` → `tool-search`).
- **Date:** Today's date in ISO format (YYYY-MM-DD).

3. If `## Completed Features` section does not exist, create it before `## Domain Index` (or at end of file if no domain index exists).

4. **Update footer timestamp** — find or create `*Last updated:*` line:

```
*Last updated: YYYY-MM-DD — by archiving <directory-name>*
```

### Global Index Template (when creating new)

```markdown
# Global Spec Index

## Completed Features

| Feature | Summary | Domain | Archived |
| ------- | ------- | ------ | -------- |

## Domain Index

<!-- Domain-specific spec groupings -->

_Last updated: YYYY-MM-DD — by archiving <directory-name>_
```

5. **Ensure CLAUDE.md references `docs/global/index.md`** — if the `## Documentation Index` section in CLAUDE.md does not reference `docs/global/index.md` in the `## Core Index` table, add it:
   ```markdown
   | `docs/global/index.md` | `archive` skill | Global spec index — completed features, domain spec groupings |
   ```

### STOP — Do NOT proceed to Phase 5 until:

- [ ] `docs/global/index.md` exists and has the new archive row
- [ ] Footer timestamp is updated to today's date
- [ ] CLAUDE.md `## Documentation Index` references `docs/global/index.md`

---

## Phase 5: Report

**Goal:** Summarize the archive operation.

```markdown
## Archive Summary

**Date:** [today]
**Features archived:** [count]

| Directory | Summary   | Domain   |
| --------- | --------- | -------- |
| [dir]     | [summary] | [domain] |

**Global index updated:** `docs/global/index.md`
```

---

## Artifact Directory Structure Reference

### Pre-Archive (`docs/changes/`)

```
docs/changes/<date>_<topic>/
├── plan.md          # planning skill artifact
├── design.md        # brainstorming skill artifact
├── intent.md        # interview-me skill artifact
├── prd.md           # prd-generation skill artifact
└── specs/           # spec-writing skill artifacts
    ├── 01-xxx.md
    ├── 02-xxx.md
    └── ...
```

### Post-Archive (`docs/archive/`)

```
docs/archive/<date>_<topic>/
├── plan.md
├── design.md
├── intent.md
├── prd.md
└── specs/
    ├── 01-xxx.md
    ├── 02-xxx.md
    └── ...
```

---

## Anti-Patterns / Common Mistakes

| Anti-Pattern                           | Why It Is Wrong                         | Correct Approach                              |
| -------------------------------------- | --------------------------------------- | --------------------------------------------- |
| Archiving without git history check    | Checkboxes can be ticked prematurely    | Cross-reference `[x]` with `git log`          |
| Archiving features with open tasks     | Incomplete work becomes invisible       | Only archive when ALL `[ ]` are resolved      |
| Moving without user confirmation       | Destructive — user may need those docs  | Always get explicit approval in Phase 2       |
| Skipping the global index update       | Feature becomes undiscoverable          | Always update `docs/global/index.md`          |
| Analyzing source code during archive   | This is archive, not code review        | Check only documents and git history          |
| Splitting the directory (partial move) | Loses full feature context              | Always `mv` the entire `<date>_<topic>` dir   |
| Archiving before feature is done       | Artifacts still relevant to active work | Only archive when plan.md tasks are all `[x]` |

---

## Anti-Rationalization Guards

- **[HARD-GATE]** Do NOT archive without confirming `[x]` completion against git history (Phase 1)
- **[HARD-GATE]** Do NOT move files without explicit user approval (Phase 2)
- **[HARD-GATE]** Do NOT skip the global index update (Phase 4)
- **Do NOT** analyze source code — this is not code review
- **Do NOT** archive directories where ANY task is still `[ ]`
- **Do NOT** archive low-confidence candidates without manual review
- **Do NOT** split feature directories — always archive as a whole `<date>_<topic>` unit

---

## Integration Points

| Skill                            | Relationship                                                                              |
| -------------------------------- | ----------------------------------------------------------------------------------------- |
| `code-review`                    | Archive checks document completion; code review checks code quality — complementary gates |
| `spec-writing`                   | Specs define features; archive retires them when done                                     |
| `planning`                       | Plans track tasks; archive verifies `[x]` before retirement                               |
| `brainstorming`                  | Design docs (`design.md`) are archived alongside the feature directory                    |
| `interview-me`                   | Intent docs (`intent.md`) are archived alongside the feature directory                    |
| `prd-generation`                 | PRD docs (`prd.md`) are archived alongside the feature directory                          |
| `finishing-a-development-branch` | Branch cleanup often precedes archive                                                     |
| `task-management`                | Task status feeds into archive completion check                                           |

---

## Concrete Example

### Pre-Archive State

```
docs/changes/2026-05-10_color-extraction/
├── plan.md                    # 6/6 tasks [x], git log shows 4 matching commits
├── design.md
├── intent.md
├── prd.md
└── specs/
    ├── 01-color-extraction.md
    ├── 02-palette-rendering.md
    └── 03-export-formats.md
```

### Archive Command

```
User: /archive
→ Phase 1 discovers 2026-05-10_color-extraction (6/6 [x], 4 matching commits → High confidence)
→ Phase 2 presents candidate, user approves
→ Phase 3 mv docs/changes/2026-05-10_color-extraction docs/archive/
→ Phase 4 updates docs/global/index.md with archive row + timestamp
→ Phase 5 reports: "1 feature archived: color-extraction"
```

### Post-Archive State

```
docs/archive/2026-05-10_color-extraction/
├── plan.md
├── design.md
├── intent.md
├── prd.md
└── specs/
    ├── 01-color-extraction.md
    ├── 02-palette-rendering.md
    └── 03-export-formats.md

docs/global/index.md             # Updated: new row + timestamp
docs/changes/                    # Clean (directory removed)
```

---

## Skill Type

**RIGID** — The five phases are sequential and mandatory. Git history cross-reference, user approval gate, and global index update must be followed exactly. Never inspect source code. Move directories as a whole — never split.
