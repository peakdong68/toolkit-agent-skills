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
   → `subagent-driven-development`: Large execution (3+ independent tasks), parallel with review gates
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
### Create Product Requirements PRD

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

### Meta — Discover which skill applies

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [using-toolkit](skills/using-toolkit/SKILL.md) | Entry point that establishes how to find, select, and use all toolkit skills | Starting a session, receiving a new task, or uncertain which skill applies |
| [self-learning](skills/self-learning/SKILL.md) | Auto-discovers and remembers project context, patterns, and preferences | Onboarding to a new project, encountering unexpected patterns, or when assumptions are corrected |

### Core — Always-on protection

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [resilient-execution](skills/resilient-execution/SKILL.md) | Retries with at least 3 genuinely different approaches before giving up | A task fails, an approach doesn't work, or errors are encountered |
| [circuit-breaker](skills/circuit-breaker/SKILL.md) | Detects stalled loops, enforces rate limits, protects config files, manages cooldown recovery | Autonomous loops running, repeated operations, or stagnation patterns detected |
| [auto-improvement](skills/auto-improvement/SKILL.md) | Continuously tracks effectiveness, classifies errors, recognizes patterns, improves workflows | Activates automatically every session — no manual invocation needed |
| [verification-before-completion](skills/verification-before-completion/SKILL.md) | 5-step HARD-GATE protocol requiring fresh evidence before claiming completion | Before marking a task done, delivering a feature, or claiming "it's finished" |

### Define — Clarify what to build

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [interview-me](skills/interview-me/SKILL.md) | One-question-at-a-time interview that extracts what the user actually wants instead of what they think they should want, until ~95% confidence | The ask is underspecified, or the user invokes "interview me" / "grill me" |
| [brainstorming](skills/brainstorming/SKILL.md) | Structured divergent/convergent thinking to turn vague ideas into concrete proposals | You have a rough concept that needs exploration |
| [spec-writing](skills/spec-writing/SKILL.md) | Write a PRD covering objectives, commands, structure, code style, testing, and boundaries before any code | Starting a new project, feature, or significant change |
| [prd-generation](skills/prd-generation/SKILL.md) | Converts product vision into structured PRDs with user stories and priorities | A new product feature needs documented requirements |
| [reverse-engineering-specs](skills/reverse-engineering-specs/SKILL.md) | Generates implementation-free behavioral specs from existing codebases | Inheriting legacy code, or needing specs for undocumented features |

### Plan — Structure the implementation

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [planning](skills/planning/SKILL.md) | Structured 5-phase planning: context → questions → approaches → document → handoff | Before any implementation task, feature request, bug fix, or refactor |
| [task-decomposition](skills/task-decomposition/SKILL.md) | Hierarchical task breakdown, dependency mapping, parallelization analysis, critical path planning | Complex tasks need decomposition into manageable subtasks |

### Execute — Build and deliver

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [task-management](skills/task-management/SKILL.md) | Breaks work into discrete tracked steps with progress reporting and checkpoint reviews | An approved plan needs conversion to tracked tasks |
| [executing-plans](skills/executing-plans/SKILL.md) | Executes approved plan documents in batches with TDD and checkpoint reviews | A single focused task with an approved plan to execute |
| [subagent-driven-development](skills/subagent-driven-development/SKILL.md) | Dispatches subagents for parallel execution with two-stage review gates (spec compliance + code quality) | 3+ independent tasks, speed matters, tasks have clear acceptance criteria |
| [dispatching-parallel-agents](skills/dispatching-parallel-agents/SKILL.md) | Coordinates multiple independent subagents working on unrelated subtasks in parallel | Subtasks touch different files, serial execution would be significantly slower |
| [autonomous-loop](skills/autonomous-loop/SKILL.md) | Ralph-style iterative development: plan → build → status check → loop until done | Autonomous dev sessions, `/ralph` or `/loop` commands |
| [ralph-status](skills/ralph-status/SKILL.md) | Structured progress reporting with EXIT_SIGNAL protocol and dual-condition exit gates | End of every autonomous loop iteration |

### QA — Test, review, and verify

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [code-review](skills/code-review/SKILL.md) | Reviews code against plans and standards, categorizes as Critical/Important/Suggestion | Task completion, before merge, verifying work meets requirements |
| [test-driven-development](skills/test-driven-development/SKILL.md) | Enforces strict RED-GREEN-REFACTOR cycle — no production code without a failing test | Writing any new code, adding features, fixing bugs that require code changes |
| [testing-strategy](skills/testing-strategy/SKILL.md) | Selects test frameworks, defines coverage thresholds, establishes testing patterns per project | New project setup, CI/CD pipeline design, coverage audit, framework migration |
| [systematic-debugging](skills/systematic-debugging/SKILL.md) | 4-phase debugging: observe → hypothesize → experiment → fix, prevents shotgun debugging | Test failures, runtime errors, unexpected behavior, performance regressions |
| [acceptance-testing](skills/acceptance-testing/SKILL.md) | Acceptance-driven backpressure with behavioral validation gates | Spec-to-code validation, feature completion verification, pre-merge acceptance gate |
| [llm-as-judge](skills/llm-as-judge/SKILL.md) | Evaluates subjective quality criteria using structured rubrics (tone, UX feel, readability) | Documentation quality check, error message tone review, design aesthetic review |
| [security-review](skills/security-review/SKILL.md) | OWASP Top 10, auth patterns, input validation, secrets management, dependency audit | Auth implementation, input handling, secrets management, pre-deployment security check |
| [performance-optimization](skills/performance-optimization/SKILL.md) | Profiling, caching strategies, bundle optimization, Web Vitals, database query tuning | Slow page loads, poor Web Vitals, database timeouts, large bundle sizes |
| [webapp-testing](skills/webapp-testing/SKILL.md) | Playwright-based E2E testing, screenshot comparison, browser log analysis, a11y audit | E2E test setup, visual regression testing, CI test pipeline |

### Specialize — Domain expertise

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [senior-frontend](skills/senior-frontend/SKILL.md) | React/Next.js/TypeScript expert with rigorous component architecture, state management, >85% test coverage | React component development, Next.js pages, state management design |
| [senior-backend](skills/senior-backend/SKILL.md) | API design, microservices, event-driven systems, database integration, caching, observability | REST/GraphQL APIs, service architecture, message queues, health checks |
| [senior-architect](skills/senior-architect/SKILL.md) | System design, scalability analysis, trade-off evaluation, ADR writing | New system design, technology selection, scaling strategy, infrastructure topology |
| [senior-fullstack](skills/senior-fullstack/SKILL.md) | End-to-end TypeScript: database → API → UI, with tRPC/Prisma/Next.js/Auth | Full-stack feature implementation, DB-to-UI pipeline, auth setup |
| [senior-devops](skills/senior-devops/SKILL.md) | CI/CD, Docker, Kubernetes, Terraform, monitoring, zero-downtime deployments | DevOps, containerization, infrastructure-as-code, observability |
| [senior-data-scientist](skills/senior-data-scientist/SKILL.md) | ML pipelines, statistical analysis, feature engineering, model selection, experiment tracking | Dataset exploration, model training, hyperparameter tuning, visualization |
| [senior-prompt-engineer](skills/senior-prompt-engineer/SKILL.md) | Prompt design, optimization, few-shot, chain-of-thought, structured output, evaluation frameworks | Creating new prompts, A/B testing prompts, building evaluation frameworks |
| [clean-code](skills/clean-code/SKILL.md) | SOLID, DRY, code smell detection, naming conventions, complexity reduction, error handling | Code quality review, refactoring guidance, technical debt reduction |
| [react-best-practices](skills/react-best-practices/SKILL.md) | React hooks design, component composition, Server Components, error boundaries, render optimization | Hook design, Server/Client component decisions, error boundary placement |

### Design — Architecture and interfaces

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [api-design](skills/api-design/SKILL.md) | REST/GraphQL/tRPC endpoint design, request/response schemas, OpenAPI specifications | Designing API endpoints, generating OpenAPI specs, choosing API paradigms |
| [database-schema-design](skills/database-schema-design/SKILL.md) | Data modeling, migration planning, index design, query optimization, SQL/NoSQL selection | Designing database schemas, creating migrations, modeling data relationships |
| [frontend-ui-design](skills/frontend-ui-design/SKILL.md) | Component architecture, responsive layouts, design systems, state management selection | Designing UI components, creating component architectures, choosing state management |

### Creative — Visual design and media

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [ui-ux-pro-max](skills/ui-ux-pro-max/SKILL.md) | Full UI/UX design intelligence: 67 styles, 161 palettes, 57 fonts, chart selection | Complete design, color palette, typography, accessibility, responsive design |
| [ui-design-system](skills/ui-design-system/SKILL.md) | Design tokens, component libraries, theme systems, Tailwind CSS v4 responsive patterns | Building design systems, component libraries, dark mode tokens, brand themes |
| [canvas-design](skills/canvas-design/SKILL.md) | HTML Canvas, SVG, D3.js data visualization, generative art | Canvas, SVG, charts, data visualization, interactive animations |
| [mobile-design](skills/mobile-design/SKILL.md) | React Native/Flutter/SwiftUI patterns, platform HIG compliance, gestures, offline-first | Mobile app design, iOS/Android, cross-platform development |
| [ux-researcher-designer](skills/ux-researcher-designer/SKILL.md) | User research, personas, journey maps, usability testing, information architecture | User research, usability tests, card sorting, heuristic evaluation |
| [artifacts-builder](skills/artifacts-builder/SKILL.md) | Standalone HTML/CSS/JS artifacts, interactive demos, prototypes, visual tools | Standalone pages, interactive demos, prototypes with no build step |

### Docs — Documentation and archiving

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [tech-docs-generator](skills/tech-docs-generator/SKILL.md) | Generates API references, architecture docs, READMEs, component docs from code | Generating or updating technical documentation |
| [writing-skills](skills/writing-skills/SKILL.md) | Creates new skills with TDD: test prompts → minimal implementation → harden → validate | Creating new skills, commands, or agent definitions |
| [archive](skills/archive/SKILL.md) | Archives completed features, updates global spec index, pre-archive validation | Feature completion, sprint wrap-up, cleaning up stale spec/plan directories |

### Ops — Deploy and automate

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [deployment](skills/deployment/SKILL.md) | CI/CD pipelines, deployment configs, release checklists, environment management | New project needs deployment, migrating CI/CD, adding staging/production |
| [using-git-worktrees](skills/using-git-worktrees/SKILL.md) | Creates isolated Git worktrees for parallel development without interference | Starting a new feature branch, working on multiple tasks without stashing |
| [finishing-a-development-branch](skills/finishing-a-development-branch/SKILL.md) | Structured branch completion: merge, create PR, cleanup, archive | Branch work is done, ready to merge, creating a PR |
| [git-commit-helper](skills/git-commit-helper/SKILL.md) | Conventional commits, semantic versioning, changelog generation | Help with commit messages, version bumping, changelog generation |
| [mcp-builder](skills/mcp-builder/SKILL.md) | MCP server development: tool definitions, resource management, prompt templates, transport | Building MCP servers, creating tools for AI clients |
| [agent-development](skills/agent-development/SKILL.md) | Build AI agents: tool use patterns, memory management, planning strategies, guardrails | Building AI agents, tool use, multi-agent coordination, safety guardrails |

### Business — Content and marketing

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [content-research-writer](skills/content-research-writer/SKILL.md) | Research methodology, long-form content, academic citations, fact-checking | Whitepapers, research articles, case studies, evidence-based arguments |
| [content-creator](skills/content-creator/SKILL.md) | Marketing copy, social media content, brand voice, ad copy, newsletters | Social media posts, email campaign copy, landing page text, ad copy |

### Productivity — Project organization

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [file-organizer](skills/file-organizer/SKILL.md) | Project structure: monorepo patterns, feature-based architecture, naming conventions, barrel exports | Restructuring projects, setting up monorepos, defining naming conventions |

 
---

## Agents

| Agent | What It Does | Use When |
|-------|-------------|-----------|
| [planner](agents/planner.md) | Creates implementation plans, analyzes architecture, evaluates trade-offs | Multi-step feature work needs a structured plan before coding |
| [code-reviewer](agents/code-reviewer.md) | Reviews code against plans and standards, categorizes Critical/Important/Suggestion | After task completion, before merge, quality verification needed |
| [prd-writer](agents/prd-writer.md) | Generates structured PRDs with user stories and priorities from requirements | Product requirements need formal documentation |
| [doc-generator](agents/doc-generator.md) | Generates API references, architecture docs, READMEs from code | Technical documentation needs generation or updating |
| [spec-reviewer](agents/spec-reviewer.md) | Reviews implementation against spec acceptance criteria for compliance | After implementation, verifying spec compliance |
| [quality-reviewer](agents/quality-reviewer.md) | Reviews code quality, patterns, performance, and security | Code review phase needs comprehensive quality assessment |
| [loop-orchestrator](agents/loop-orchestrator.md) | Manages autonomous dev loops: task selection, exit evaluation, status reporting | Ralph-style iterative development sessions |
| [spec-writer](agents/spec-writer.md) | Generates JTBD behavioral specs with Given/When/Then acceptance criteria | Formal specs needed for a feature |
| [acceptance-judge](agents/acceptance-judge.md) | Evaluates subjective quality via structured scoring rubrics (tone, UX, readability) | LLM-as-judge evaluation pattern needed |
| [frontend-developer](agents/frontend-developer.md) | Three-phase frontend dev: context discovery → component development → test handoff | Frontend feature development, React component implementation |
| [ui-ux-designer](agents/ui-ux-designer.md) | Design system generation, component specs, style guides, color schemes | Building design systems, UI/UX design specs needed |
| [backend-architect](agents/backend-architect.md) | Service boundary design, contract-first API, scalability planning | Backend service architecture design, API contract definition |
| [context-manager](agents/context-manager.md) | Project context tracking, dependency mapping, tech stack documentation | Onboarding to a new project, understanding the full codebase |
| [database-architect](agents/database-architect.md) | Multi-database strategy, data modeling, event sourcing, migration planning | Database architecture design, schema changes |
| [architect-reviewer](agents/architect-reviewer.md) | Architecture review, scalability assessment, technical debt identification | Architecture decision review, system refactoring assessment |
| [typescript-pro](agents/typescript-pro.md) | Advanced TypeScript type patterns, conditional types, branded types | Complex type design, type safety guarantees |
| [task-decomposer](agents/task-decomposer.md) | Hierarchical task breakdown, dependency analysis, parallelization strategy | Complex tasks need WBS decomposition |
| [mobile-developer](agents/mobile-developer.md) | Cross-platform mobile dev, React Native/Flutter/SwiftUI patterns | Mobile app development, platform-specific feature implementation |

### Slash Commands

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
| `/mcp` | MCP server development | `mcp-builder` |
| `/commit` | Git commit helper | `git-commit-helper` |
| `/decompose` | Task decomposition | `task-decomposition` |
| `/archive` | Archive completed features | `archive` |

 

## Ralph Integration  — Autonomous iterative development loops 

The toolkit integrates key concepts from [Ralph](https://github.com/frankbria/ralph-claude-code) and the [Ralph Playbook](https://github.com/ClaytonFarr/ralph-playbook) — an autonomous AI development methodology by Geoffrey Huntley.

### Autonomous Loop (`/ralph` or `/loop`)

Iterative development cycle: **PLANNING** → **BUILDING** → **STATUS CHECK** → repeat until done.

- **ONE task per loop** — each iteration selects and completes exactly one task
- **Context efficiency** — main context at 40-60% utilization, up to 5 parallel read subagents
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

 

---

## License

[MIT](LICENSE)
