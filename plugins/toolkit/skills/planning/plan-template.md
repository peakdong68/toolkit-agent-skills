# [Feature Name] Implementation Plan ([N]) — [Phase Name]

> Standard structure for plan documents. Referenced by `skills/planning/SKILL.md` Phase 4. Produce plan documents following this structure.

**Goal:** [One sentence — what this plan delivers]

**Tech Stack:** [Frameworks, languages, key dependencies with versions]

**Prerequisites:** [Preceding plans or conditions, e.g., "plan-1.md (Tasks 1-4) completed"]

## Change Overview

[One paragraph summarizing all changes — what's added, modified, key decisions.]

- [Change point 1]
- [Change point 2]
- Key decision: [Most important technical decision and rationale]

---

### Task 0: Environment Preparation

**Background:**
Ensure build and test toolchains are available in the current dev environment to prevent downstream task blockage.

**Steps:**
- [ ] Verify runtime available
  - `[verification command]`
  - Expected: [expected output]
- [ ] Verify build tool available
  - `[build check command]`
  - Expected: [expected output]
- [ ] Verify test framework available
  - `[test framework check command]`
  - Expected: [expected output]

**Verification:**
- [ ] Build command succeeds
  - `[build command]`
  - Expected: [expected output]
- [ ] Existing tests pass (if any)
  - `[test command]`
  - Expected: [expected output]

---

### Task [N]: [Short Descriptive Title]

**Background:**
- Context: [Where this task fits in the feature and its role]
- Reason: [Why this change is needed, what problem it solves]
- Impact: [Upstream tasks this depends on, downstream tasks that depend on it]

**Spec AC:** [Which acceptance criteria from the spec this task satisfies — omit if no spec]

**Files:**
- Create: `path/to/new/file.ts`
- Create: `path/to/new/file2.ts`
- Modify: `path/to/existing/file.ts`
- Test: `tests/path/to/test.ts`
- (Omit categories with no files)

**Steps:**
- [ ] [Step title] — [One-line summary of what to do]
  - Location: `path/to/file.ts:line-range` or `function/component name`
  - Operation: [Concrete code change — not a vague description, an executable instruction]
  - Reason: [Why this approach, not an alternative]
- [ ] [Step title] — [Same structure as above]
  - Location: [Same]
  - Operation: [Same]
  - Reason: [Same]

**Verification:**
- [ ] [Check item title]
  - `[concrete shell command]`
  - Expected: [Verifiable expected output — grep count, test pass flag, errors should be empty, etc.]
- [ ] [Check item title]
  - `[same]`
  - Expected: [same]

**Cognitive Changes (if applicable):**
- [ ] [CLAUDE.md] [Info to persist to project memory — new files, exported functions, architectural conventions. Omit if nothing to record.]

---

[Repeat Task 1..N structure above. Tasks ordered by dependency: foundations first, dependents later. Insert checkpoint summaries every 2-3 tasks.]

## Checkpoint [N] Summary

[After every 2-3 tasks, insert a brief checkpoint summarizing what has been built and what remains.]

---

### Task [M]: [Phase Name] Acceptance

**Prerequisites:**
- [List all tasks that must be completed for this phase]
- [List environment requirements]

**End-to-End Verification:**

1. ✅ [Verification item title]
   - `[verification command]`
   - Expected: [expected output]
   - Troubleshoot: [what to check if this fails]

2. ✅ [Verification item title]
   - `[same]`
   - Expected: [same]
   - Troubleshoot: [same]
