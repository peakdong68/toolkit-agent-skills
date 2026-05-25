---
name: archive
description: 'Use when archiving completed features, moving finished work to docs/archive/, updating the global spec index, or running /archive command. Triggers on feature completion, sprint wrap-up, cleanup of stale spec/plan directories, or any request to "archive" completed work.'
---

# Archive Completed Features

## Overview

Archive completed feature directories from `docs/specs/` and `docs/plans/` to `docs/archive/specs/` and `docs/archive/plans/`, and PRD files from `docs/prds/` to `docs/archive/prds/`, preserving the original subdirectory structure. Verifies task completion via git history — not code analysis. This skill differs from `code-review`: it checks document checkboxes and git log to confirm what was done, never inspecting source code. Every archive run updates the global spec index at `docs/global/index.md`.

**Announce at start:** "I'm using the archive skill to archive completed features."

---

## Phase 1: Discover Completed Features

**Goal:** Identify candidate feature directories whose tasks are fully checked off.

### Actions

1. Use Grep Tool Scan `docs/specs/` and `docs/plans/` for feature directories:

2. For each feature directory, check task completion status:
   - Read `plan.md` or `plan-*.md` files and inspect `[x]` / `[ ]` checkbox states
   - Identify directories where ALL tasks are marked `[x]`

3. Use Grep Tool Scan `docs/prds/` for PRD files:
   - PRD files follow the naming pattern `YYYY-MM-DD-<feature>.md` (single Markdown files, not directories)
   - PRDs do not have checkboxes — completion is determined by git history: check for commits referencing the PRD's feature name or the PRD commit itself

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
| Feature Directory | Tasks Done | Git Commits | Confidence |
|-------------------|-----------|-------------|-----------|
| docs/specs/2026-05-10-login/ | 5/5 [x] | 3 matching | High |
```

2. Ask ONE clear question: "Archive these completed features?"

**STOP — Do NOT proceed to Phase 3 until user explicitly approves.**

---

## Phase 3: Execute Archive

**Goal:** Move completed feature directories to `docs/archive/` and clean up.

### Actions

1. Move spec and plan directories into the archive, preserving subdirectory structure:

```bash
mkdir -p docs/archive/specs docs/archive/plans
# Move spec directory into archive/specs/
mv docs/specs/<date>_<topic> docs/archive/specs/
# Move plan directory into archive/plans/
mv docs/plans/<date>_<topic> docs/archive/plans/
```

2. Move PRD files into the archive:

```bash
mkdir -p docs/archive/prds
# Move PRD file into archive/prds/
mv docs/prds/YYYY-MM-DD-<feature>.md docs/archive/prds/
```

3. Verify all archive locations:

```bash
ls docs/archive/specs/<date>_<topic>/    # spec files (01-*.md, etc.)
ls docs/archive/plans/<date>_<topic>/           # plan files (plan.md, design.md, etc.)
ls docs/archive/prds/YYYY-MM-DD-<feature>.md    # PRD file
```

3. **Fix relative path references** in archived documents — scan all `.md` files in `docs/archive/specs/<date>_<topic>/` and `docs/archive/plans/<date>_<topic>/` for internal relative links (e.g., `[text](../specs/...)` or `[text](../plans/...)`). Since spec and plan directories preserve their sibling relationship under `docs/archive/`, relative paths between them remain valid. However, update paths that point to resources that stayed in `docs/` (not archived).

4. Confirm original locations are clean (directories no longer exist in `docs/specs/` or `docs/plans/`, and the PRD file no longer exists in `docs/prds/`).

### STOP — Do NOT proceed to Phase 4 until:

- [ ] All confirmed directories are moved to `docs/archive/`
- [ ] Relative path references in archived documents are checked and fixed
- [ ] Original locations are clean (no lingering files)
- [ ] Archived directories contain all expected files

---

## Phase 4: Update Global Spec Index

**Goal:** Update `docs/global/index.md` to reflect the archive operation.

### Actions

1. Read `docs/global/index.md` — if it does not exist, create it with the template below.

2. **Append archive row to `## Completed Features` table** — insert at the top:

```
| [<directory-name>](../archive/plans/2026-05-10_color-extraction/) | <one-line summary> | <domain> | <today-ISO-date> |
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

4. **Ensure CLAUDE.md references `docs/global/index.md`** — if the `## Documentation Index` section in CLAUDE.md does not reference `docs/global/index.md` in the `## Core Index` table, add it:
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

## Anti-Patterns / Common Mistakes

| Anti-Pattern                                     | Why It Is Wrong                        | Correct Approach                                   |
| ------------------------------------------------ | -------------------------------------- | -------------------------------------------------- |
| Archiving without git history check              | Checkboxes can be ticked prematurely   | Cross-reference `[x]` with `git log`               |
| Archiving features with open tasks               | Incomplete work becomes invisible      | Only archive when ALL `[ ]` are resolved           |
| Moving without user confirmation                 | Destructive — user may need those docs | Always get explicit approval in Phase 2            |
| Skipping the global index update                 | Feature becomes undiscoverable         | Always update `docs/global/index.md`               |
| Analyzing source code during archive             | This is archive, not code review       | Check only documents and git history               |
| Archiving plan but not spec (or vice versa)      | Leaves orphaned half-features          | Archive matching spec+plan pairs together          |
| Archiving PRD before feature implementation      | PRD is still relevant to active work   | Only archive PRDs when their features are complete |
| Forgetting to archive PRDs alongside specs/plans | PRD becomes stale in docs/prds/        | Archive PRDs with their matching spec+plan pair    |

---

## Anti-Rationalization Guards

- **[HARD-GATE]** Do NOT archive without confirming `[x]` completion against git history (Phase 1)
- **[HARD-GATE]** Do NOT move files without explicit user approval (Phase 2)
- **[HARD-GATE]** Do NOT skip the global index update (Phase 4)
- **Do NOT** analyze source code — this is not code review
- **Do NOT** archive directories where ANY task is still `[ ]`
- **Do NOT** archive low-confidence candidates without manual review

---

## Integration Points

| Skill                            | Relationship                                                                              |
| -------------------------------- | ----------------------------------------------------------------------------------------- |
| `code-review`                    | Archive checks document completion; code review checks code quality — complementary gates |
| `spec-writing`                   | Specs define features; archive retires them when done                                     |
| `planning`                       | Plans track tasks; archive verifies `[x]` before retirement                               |
| `finishing-a-development-branch` | Branch cleanup often precedes archive                                                     |
| `task-management`                | Task status feeds into archive completion check                                           |
| `prd-generation`                 | PRDs define high-level requirements; archive retires them when features are implemented   |

---

## Concrete Example

### Pre-Archive State

```
docs/specs/2026-05-10-color-extraction/
├── 01-color-extraction.md
├── 02-palette-rendering.md
└── 03-export-formats.md

docs/plans/2026-05-10_color-extraction/
└── plan.md                    # 6/6 tasks [x], git log shows 4 matching commits
```

### Archive Command

```
User: /archive
→ Phase 1 discovers 2026-05-10-color-extraction (6/6 [x], 4 matching commits → High confidence)
→ Phase 2 presents candidate, user approves
→ Phase 3 moves both directories to docs/archive/
→ Phase 4 updates docs/global/index.md with archive row + timestamp
→ Phase 5 reports: "1 feature archived: color-extraction"
```

### Post-Archive State

```
docs/archive/specs/2026-05-10-color-extraction/
├── 01-color-extraction.md
├── 02-palette-rendering.md
└── 03-export-formats.md

docs/archive/plans/2026-05-10_color-extraction/
└── plan.md

docs/global/index.md             # Updated: new row + timestamp
docs/specs/                      # Clean (directory removed)
docs/plans/                      # Clean (directory removed)
```

---

## Skill Type

**RIGID** — The five phases are sequential and mandatory. Git history cross-reference, user approval gate, and global index update must be followed exactly. Never inspect source code.
