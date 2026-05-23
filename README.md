# toolkit-agents

## Quick Start

**Marketplace install:**

```
/plugin marketplace add peakdong68/toolkit-agent-skills

/plugin install toolkit@toolkit-agents
```

**Local / development:**

```bash

git clone https://github.com/peakdong68/toolkit-agent-skills.git

claude --plugin-dir /path/to/toolkit-agent-skills

```



---


##  WORKFLOW EXAMPLES

### New Feature (Full Lifecycle)

```
1. /brainstorm     → Explore the idea, create design doc
2. /specs          → Write specifications with JTBD methodology
3. /plan           → Create implementation plan with bite-sized tasks; choose execution skill:
   → `task-management`            : Standard execution (< 3 tasks), sequential tracked progress
   → `subagent-driven-development`: Large execution (2+ independent tasks), parallel with review gates
   → `autonomous-loop`            : Autonomous development session, Ralph-style iterative execution
   → `executing-plans`            : Single focused task, direct plan execution (/execute)
4. /execute        → Execute plan with TDD and tracked progress
5. /review         → Verify against plan and standards
6. /verify         → Confirm everything works with fresh evidence
7. finishing-a-development-branch   → Merge, PR, or cleanup
8. /archive        → Archive completed feature to docs/archive/
```

### Bug Fix

```
1. /debug          → Systematic 4-phase debugging methodology
2. /tdd            → Write test that reproduces bug, then fix
3. /review         → Verify the fix
4. /verify         → Confirm fix with fresh evidence
```

### Ralph Autonomous Session

```
1. /specs          → Write or audit specifications
2. /ralph          → Start autonomous loop
   → PLANNING MODE: analyze specs, generate IMPLEMENTATION_PLAN.md
   → BUILDING MODE: select task, implement, test, commit
   → STATUS CHECK: produce RALPH_STATUS, evaluate exit gate
   → LOOP until dual-condition exit gate passes
3. /review         → Final code review
4. /verify         → Verify all acceptance tests pass
```

### Legacy Codebase Onboarding

```
1. /learn          → Scan and discover project context
2. reverse-engineering-specs → Generate specs from existing code
3. /specs          → Audit and refine generated specs
4. /plan           → Plan improvements or new features
5. /execute        → Implement with full test coverage
```

### API Design & Implementation

```
1. api-design      → Design endpoints, generate OpenAPI spec
2. /specs          → Write behavioral specifications
3. /plan           → Create implementation plan
4. testing-strategy → Define test approach
5. /tdd            → Implement with tests
6. security-review → Check for vulnerabilities
```

### Frontend Component Development

```
1. frontend-ui-design → Component architecture, a11y, responsive design
2. /plan              → Create implementation plan
3. /tdd               → Implement with tests
4. performance-opt    → Check bundle size, Web Vitals
5. /review            → Code review
```

### Database Schema Change

```
1. database-schema-design → Model data, plan migrations, indexing
2. /plan                  → Create implementation plan
3. /tdd                   → Implement with migration tests
4. /verify                → Verify migrations work both directions
```
## Create Product Requirements PRD

```
1. /prd            → Create Product Requirements Document
2. /brainstorm     → Explore approaches first, then plan
3. /specs          → PRD provides high-level requirements; specs refine them using JTBD
4. /plan           → Planning references PRD requirements to break down tasks
5. /execute        → Execute the plan, follow TDD and track progress
```

### Documentation Generation

```
1. /docs           → Generate technical documentation from code 
3. llm-as-judge    → Evaluate documentation quality
```

### Security Audit

```
1. security-review → OWASP Top 10, auth patterns, input validation
2. /plan           → Plan remediation
3. /tdd            → Fix vulnerabilities with regression tests
4. /verify         → Confirm all issues resolved
```

### Performance Optimization

```
1. performance-optimization → Profile, identify bottlenecks
2. /plan                    → Plan optimization approach
3. /tdd                     → Implement with benchmark tests
4. /verify                  → Confirm performance targets met
```

---

## Skills Overview

<details>
<summary><strong>Core (6)</strong> — Foundation skills always recommended</summary>

| Skill | Description |
|-------|-------------|
| `using-toolkit` | Master skill — establishes how to find and use all toolkit skills |
| `self-learning` | Auto-discover and remember project context |
| `resilient-execution` | Never fail — retry with alternative approaches |
| `circuit-breaker` | Loop stagnation detection, rate limiting, and recovery patterns |
| `auto-improvement` | Self-improving system, tracks effectiveness, learns from errors |
| `verification-before-completion` | 5-step verification gate before any completion claim |

</details>

<details>
<summary><strong>Process & Workflow (9)</strong> — Planning, execution, and autonomous loops</summary>

| Skill | Description |
|-------|-------------|
| `brainstorming` | Creative exploration and design before planning |
| `planning` | Structured planning before any implementation work |
| `task-management` | Break work into discrete tracked steps |
| `executing-plans` | Step-by-step execution of approved plan documents |
| `subagent-driven-development` | Same-session execution with two-stage review gates |
| `dispatching-parallel-agents` | Coordinate multiple independent agents in parallel |
| `autonomous-loop` | Ralph-style iterative development with autonomous planning and building loops |
| `ralph-status` | Structured status reporting with exit signal protocol |
| `task-decomposition` | Hierarchical breakdown, dependency mapping, parallelization |

</details>

<details>
<summary><strong>Quality Assurance (17)</strong> — Testing, review, debugging, and specialist roles</summary>

| Skill | Description |
|-------|-------------|
| `code-review` | Quality verification against plan and standards |
| `test-driven-development` | TDD workflow with RED-GREEN-REFACTOR cycle |
| `testing-strategy` | Choose testing approach based on project context |
| `systematic-debugging` | 4-phase debugging methodology with root cause analysis |
| `security-review` | OWASP Top 10, auth patterns, input validation, secrets |
| `performance-optimization` | Profiling, caching, bundle optimization, Web Vitals |
| `acceptance-testing` | Acceptance-driven backpressure with behavioral validation gates |
| `llm-as-judge` | Non-deterministic validation for subjective quality criteria |
| `senior-frontend` | React/Next.js/TypeScript specialist, >85% test coverage |
| `senior-backend` | API design, microservices, event-driven architecture |
| `senior-architect` | System design, scalability, trade-off analysis, ADRs |
| `senior-fullstack` | End-to-end development across the full stack |
| `clean-code` | SOLID, DRY, code smells, refactoring patterns |
| `react-best-practices` | React hooks, context, suspense, server components |
| `webapp-testing` | Playwright-based web testing, screenshots, browser logs |
| `senior-prompt-engineer` | Prompt design, optimization, chain-of-thought |
| `senior-data-scientist` | ML pipelines, statistical analysis, experiment design |

</details>

<details>
<summary><strong>Design (3)</strong> — API, UI, and database design</summary>

| Skill | Description |
|-------|-------------|
| `api-design` | Structured API endpoint design with OpenAPI spec |
| `frontend-ui-design` | Component architecture, responsive design, accessibility |
| `database-schema-design` | Data modeling, migrations, indexing, query optimization |

</details>

<details>
<summary><strong>Documentation (6)</strong> — PRDs, specs, and technical docs</summary>

| Skill | Description |
|-------|-------------|
| `prd-generation` | Generate Product Requirements Documents |
| `tech-docs-generator` | Generate technical documentation from code |
| `writing-skills` | Create new skills with TDD and best practices |
| `spec-writing` | JTBD-based specification writing with acceptance criteria |
| `reverse-engineering-specs` | Generate implementation-free specs from existing codebases |
| `archive` | Archive completed features, update spec index, verify before archival |

</details>

<details>
<summary><strong>Operations (7)</strong> — Git, CI/CD, DevOps, and MCP</summary>

| Skill | Description |
|-------|-------------|
| `deployment` | CI/CD pipeline generation and deploy checklists |
| `using-git-worktrees` | Isolated development environments with git worktrees |
| `finishing-a-development-branch` | Structured branch completion with merge options |
| `git-commit-helper` | Conventional commits, semantic versioning, changelogs |
| `senior-devops` | CI/CD, Docker, Kubernetes, infrastructure-as-code |
| `mcp-builder` | MCP server development, tools, resources, transport layers |
| `agent-development` | Building AI agents, tool use, memory, planning |

</details>

<details>
<summary><strong>Creative (6)</strong> — UI/UX, design systems, mobile, and canvas</summary>

| Skill | Description |
|-------|-------------|
| `ui-ux-pro-max` | Full UI/UX design intelligence with 67 styles, 161 palettes, 57 fonts |
| `ui-design-system` | Design tokens, component libraries, Tailwind CSS, responsive patterns |
| `canvas-design` | HTML Canvas, SVG, data visualization, generative art |
| `mobile-design` | React Native, Flutter, SwiftUI, platform HIG compliance |
| `ux-researcher-designer` | User research, personas, journey maps, usability testing |
| `artifacts-builder` | Generate standalone artifacts, interactive demos, prototypes |

</details>

<details>
<summary><strong>Business (3)</strong> — SEO, content, and marketing</summary>

| Skill | Description |
|-------|-------------|
| `seo-optimizer` | Technical SEO, meta tags, structured data, Core Web Vitals |
| `content-research-writer` | Research methodology, long-form content, citations |
| `content-creator` | Marketing copy, social media, brand voice |

</details>

<details>
<summary><strong>Document Processing (3)</strong> — Word, PDF, and Excel</summary>

| Skill | Description |
|-------|-------------|
| `docx-processing` | Word document generation, template filling |
| `pdf-processing` | PDF generation, form filling, OCR, merge/split |
| `xlsx-processing` | Excel manipulation, formulas, charts |

</details>

<details>
<summary><strong>Productivity & Communication (2)</strong></summary>

| Skill | Description |
|-------|-------------|
| `file-organizer` | Project structure, file naming, directory architecture |
| `email-composer` | Professional email drafting, tone adjustment |

</details>



---

## Agents & Commands

<details>
<summary><strong>18 Agents</strong> — Specialized sub-agents for parallel work</summary>

| Agent | Description |
|-------|-------------|
| `planner` | Senior architect creating implementation plans |
| `code-reviewer` | Reviews code against plan and standards |
| `prd-writer` | Generates PRD from collected requirements |
| `doc-generator` | Generates technical documentation from code |
| `spec-reviewer` | Reviews implementation against spec compliance |
| `quality-reviewer` | Reviews code quality, patterns, performance, security |
| `loop-orchestrator` | Manages autonomous development loop iterations |
| `spec-writer` | Generates JTBD specifications with acceptance criteria |
| `acceptance-judge` | Evaluates subjective quality via LLM-as-judge pattern |
| `frontend-developer` | Three-phase frontend dev with context discovery, development, handoff |
| `ui-ux-designer` | Design system generation, component specs, style guides |
| `backend-architect` | Service boundaries, contract-first API, scaling |
| `context-manager` | Project context tracking, dependency mapping |
| `database-architect` | Multi-DB strategy, domain-driven design, event sourcing |
| `architect-reviewer` | Architecture review, scalability assessment, tech debt |
| `typescript-pro` | Advanced type patterns, conditional types, branded types |
| `task-decomposer` | Hierarchical task breakdown, parallelization strategy |
| `mobile-developer` | Cross-platform mobile, platform-specific patterns |


</details>

<details>
<summary><strong>29 Slash Commands</strong> — Trigger skills directly in Claude Code</summary>

| Command | Description | Skill |
|---------|-------------|-------|
| `/plan` | Start structured planning | `planning` |
| `/brainstorm` | Start brainstorming session | `brainstorming` |
| `/execute` | Execute an approved plan | `executing-plans` |
| `/tdd` | Start TDD workflow | `test-driven-development` |
| `/debug` | Start debugging methodology | `systematic-debugging` |
| `/review` | Request code review | `code-review` |
| `/verify` | Verify completion claim | `verification-before-completion` |
| `/prd` | Generate a PRD | `prd-generation` |
| `/learn` | Scan and learn project context | `self-learning` |
| `/docs` | Generate technical docs | `tech-docs-generator` |
| `/worktree` | Set up git worktree | `using-git-worktrees` |
| `/ralph` | Start Ralph autonomous development loop | `autonomous-loop` |
| `/specs` | Write or audit specifications | `spec-writing` |
| `/loop` | Start autonomous loop iteration | `autonomous-loop` |
| `/frontend` | Senior frontend development | `senior-frontend` |
| `/backend` | Senior backend development | `senior-backend` |
| `/architect` | Architecture design and review | `senior-architect` |
| `/fullstack` | Full-stack development | `senior-fullstack` |
| `/design-system` | Design system generation | `ui-design-system` |
| `/ui-ux` | UI/UX design intelligence | `ui-ux-pro-max` |
| `/mobile` | Mobile design patterns | `mobile-design` |
| `/clean` | Clean code review | `clean-code` |
| `/devops` | DevOps and infrastructure | `senior-devops` |
| `/agent` | AI agent development | `agent-development` |
| `/seo` | SEO optimization | `seo-optimizer` |
| `/email` | Email composition | `email-composer` |
| `/mcp` | MCP server development | `mcp-builder` |
| `/commit` | Git commit helper | `git-commit-helper` |
| `/decompose` | Task decomposition | `task-decomposition` |
| `/archive` | Archive completed features | `archive` |

</details>



---

<details>
<summary><strong>Ralph Integration</strong> — Autonomous iterative development loops</summary>

The toolkit integrates key concepts from [Ralph](https://github.com/frankbria/ralph-claude-code) and the [Ralph Playbook](https://github.com/ClaytonFarr/ralph-playbook) — an autonomous AI development methodology by Geoffrey Huntley.

### Autonomous Loop (`/ralph` or `/loop`)

Iterative development cycle: **PLANNING** → **BUILDING** → **STATUS CHECK** → repeat until done.

- **ONE task per loop** — each iteration selects and completes exactly one task
- **Context efficiency** — main context at 40-60% utilization, up to 500 parallel read subagents
- **Upstream/downstream steering** — specs shape inputs, tests/builds/lints create backpressure
- **Dual-condition exit gate** — requires both completion language AND explicit `EXIT_SIGNAL: true`

### Circuit Breaker

Safety mechanism preventing infinite loops and resource exhaustion:

- Opens after 3 loops with no progress, 5 identical errors, or 70% output decline
- 30-minute cooldown before retry
- Rate limiting (configurable calls per hour)
- File protection prevents accidental config deletion

### JTBD Specifications (`/specs`)

Jobs to Be Done methodology for writing implementation-free specs:

- Break requirements into topics of concern
- "One Sentence Without 'And'" test for proper scoping
- Acceptance criteria in Given/When/Then format
- SLC (Simple/Lovable/Complete) release planning

### Acceptance Testing & LLM-as-Judge

- **Acceptance testing** — backpressure chain: specs → tests → code (fix code, not specs)
- **LLM-as-judge** — structured rubric evaluation for subjective criteria (tone, UX, readability)

</details>


---

## License

[MIT](LICENSE)
