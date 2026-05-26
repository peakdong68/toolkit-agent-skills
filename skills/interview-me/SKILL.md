---
name: interview-me
description: Extracts what the user actually wants instead of what they think they should want. Achieves this through one-question-at-a-time interview until ~95% confidence about the underlying intent. Use when an ask is underspecified ("build me X" without "for whom" or "why now"), when the user explicitly invokes ("interview me", "grill me", "are we sure?", "stress-test my thinking"), or when you catch yourself silently filling in ambiguous requirements before any plan, spec, or code exists.
---

# Interview Me

## Overview

What people ask for and what they actually want are different things. They ask for "a dashboard" because that's what one asks for, not because a dashboard solves their problem. They say "make it faster" without a number to hit.

The cheapest moment to find this gap is before any plan, spec, or code exists. Once you've started building, switching costs are real, and the user will rationalize the wrong thing into a "good enough" thing. The misfit gets locked in.

This skill closes the gap before it costs anything. The other Define-phase skills assume you already know roughly what you want: `brainstorming` generates variations from an idea, `spec-writing` writes the requirements down. Interview-me is the part before all of those, where you ask one question at a time, with your best guess attached, until you can predict what the user is going to say before they say it.

## When to Use

Apply this skill when:

- The ask is missing at least one of: **who** the user is, **why** they want it, what **success** looks like, what the binding **constraint** is
- The request is conventional rather than specific ("build me X", "make it faster") and you can't unpack the convention without guessing
- You're tempted to start with assumptions you haven't surfaced
- The user hasn't said which value they're optimizing for when two reasonable ones are in tension (simplicity vs. flexibility, cost vs. speed)
- The user explicitly invokes: "interview me", "grill me", "before we start, are we sure?", "stress-test my thinking"

**When NOT to use:**

- The ask is unambiguous and self-contained ("rename this variable", "fix this typo")
- The user has explicitly asked for speed over verification
- Pure information requests ("how does X work?", "what does this code do?")
- Mechanical operations (renames, formats, file moves)
- You already have ≥95% confidence; re-read the stop condition below before assuming you don't

## Loading Constraints

This skill needs a live, responsive user. **Do not invoke in non-interactive contexts** like CI pipelines, scheduled runs, `/loop`, or `autonomous-loop`. If you're in one of those and the ask is underspecified, flag that as a blocker for the user instead of guessing.

## The Process

### Step 1: Hypothesize, with a confidence number

Before asking anything, write down your current best read of what the user wants in **one sentence**, plus an honest confidence number (0–100%):

```
HYPOTHESIS: You want a way to answer "how are we doing?" in standup, and "dashboard" was the convention that came to mind.
CONFIDENCE: ~30% — missing: who it's for, what "metrics" means in context, and what success looks like
```

The number forces honesty. If you wrote down a high number but can't actually predict the user's reactions to the next three questions you'd ask, the number is wrong. Start at the confidence level you can defend.

When confidence is below ~70%, append a brief reason on the same line — what's still unresolved or missing. This tells the user exactly what the interview needs to surface, and prevents the number from being a vague signal.

### Step 2: Ask one question at a time, each with a guess attached

Format:

```
Q: <one focused question>
GUESS: <your hypothesis for the answer, with the reasoning that produced it>
```

Wait for the user to react before asking the next question.

**Why one at a time, not a batch:**

- The user can't react to your hypotheses if you bury them in a list
- Batches encourage skim-reading and surface answers
- The third question often depends on the answer to the first; asking them all at once locks in the wrong framing
- The user's energy for thinking carefully is finite; spend it one question at a time

**Why attach a guess:**

- The user reacts faster to a wrong guess than they generate an answer from scratch
- It commits you to a hypothesis you can be visibly wrong about, which keeps you honest
- It surfaces _your_ assumptions, which is what the interview is meant to expose

The risk here is a polite user agreeing with your guess to be agreeable. Mitigate by being visibly willing to be wrong, and occasionally guess in a direction you expect the user to push back on.

### Step 3: Listen for "want vs. should want"

The most dangerous answers are the ones where the user says what a thoughtful answer _sounds like_ rather than what they actually want. Watch for:

- Answers that pattern-match best-practice talk ("I want it to be scalable", "clean architecture") without specifics
- Answers that defer to convention ("the way most apps do it", "the standard approach")
- Phrases like "I should probably…", "I think I'm supposed to…", "good engineering practice says…"
- Buzzwords as goals — when "modern", "scalable", "robust" are the answer instead of a specific outcome

When you hear these, the question to ask is:

> _"If you didn't have to justify this to anyone, what would you actually want?"_

That single question often does more work than the previous five.

### Step 4: Restate intent in the user's own words

When your confidence is high, write back what you now think the user wants. Keep it tight (5–8 lines), use their language where possible, and structure it so the user can confirm or correct line by line:

```
Here's what I now think you want:

- Outcome:      <one line>
- User:         <one line — who benefits>
- Why now:      <one line — what changed>
- Success:      <one line — how we know it worked>
- Constraint:   <one line — the binding limit>
- Out of scope: <one line — what we're explicitly not doing>

Yes / no / refine?
```

Including "Out of scope" is non-negotiable. Half of misalignment is silent disagreement about what is _not_ being built.

### Step 5: Confirm — explicit yes, not "whatever you think"

The gate is an explicit "yes." The following are **not** yes:

- "Whatever you think is best." → The user is delegating, which means they don't have 95% confidence either. Re-ask with two concrete options framed as a choice.
- "Sounds good." → Ambiguous. Ask: "Anything you'd refine?" Silence isn't confirmation.
- "Sure, let's go." → Often a polite exit, not an endorsement. Same follow-up.
- Silence followed by "okay let's start." → The user has given up on the interview, not converged. Stop and ask whether you've missed something.

If they correct you, fold the correction in and restate. Loop until you get an explicit yes.

### Step 6: Route to downstream skill — never direct to code

**[HARD-GATE:ROUTE]** After the user confirms the restate with an explicit yes, you MUST recommend the appropriate downstream skill. Interview-me is a Define-phase skill; its job is to clarify intent, not act on it. The confirmed intent feeds the next phase — it is never the final step before implementation.

**Which downstream skill to recommend:**

| Intent characteristic | Route to | Why |
|---|---|---|
| Concrete: clear who, what, why, success criteria, constraint | `/spec-writing` then `/plan` | Write the spec from confirmed intent, then plan implementation |
| Needs scoping: "I want X but I don't know what shape it takes" | `/brainstorming` | Generate variations against the now-explicit intent, then re-check |
| Trivial / self-contained action (rename, fix typo) | None — proceed directly | Interview-me shouldn't have been invoked; see "When NOT to use" |

**Format the handoff explicitly.** After confirmation, produce the restate one final time and route:

```
Confirmed. Here's the summary:

- Outcome:      <one line>
- User:         <one line>
- Why now:      <one line>
- Success:      <one line>
- Constraint:   <one line>
- Out of scope: <one line>

Next: I recommend /spec-writing to capture this as a spec, then /plan for implementation. Sound good?
```

**What NOT to do after confirmation:**

- Start writing code or suggesting libraries, frameworks, file structures
- Produce a task list, architecture sketch, or component tree
- Generate any artifact beyond the restate and routing recommendation
- Ask "want me to start coding?" — you already know the answer is no; route instead

If the user pushes back and says "just start coding," remind them: the interview surfaced what they want, but not how to build it. Spec and plan exist to prevent building the wrong thing the right way.

### The 95% Confidence Stop

You're done when you can answer yes to this:

> _Can I predict the user's reaction to the next three questions I would ask?_

If yes, you have shared understanding. Stop interviewing and produce the restate. If no, you're not done; ask the next question.

This is a checkable test, not a vibe. It also has a floor: if you've gone several rounds and still can't predict, that's information about the ask, not a reason to keep grinding. Stop and tell the user: "I've asked X questions and I still can't predict your reactions. Something foundational is missing. Want to step back?"

## Output

The output of this skill is a **confirmed statement of intent paired with a downstream routing recommendation**: the restate from Step 4, an explicit yes from Step 5, and a routing recommendation from Step 6. The restate + routing is the deliverable. Code, task lists, and implementation are downstream; they consume the intent this skill produces — through the routed skill, never directly.

If the user wants the intent to persist (a multi-session project, a handoff to another collaborator), offer to save it to `docs/intent/[topic].md`. Only save if they confirm.

## Example

A short before-and-after.

**Without `interview-me`:**

```
User:  build me a dashboard for our metrics
Agent: <starts proposing chart libraries and layouts>
```

The agent has assumed: who it's for, what metrics, what "for our team" means, what success looks like. None of these are stated. Every assumption is a place the user can later say "that's not what I meant."

**With `interview-me`:**

```
User: build me a dashboard for our metrics

Agent:
HYPOTHESIS: You want a way to answer "how are we doing?" in standup, and "dashboard" came to mind because that's the conventional answer.
CONFIDENCE: ~30% — missing: who it's for, what "metrics" are, and what success looks like

Q:     When you say "how are we doing?", who's asking — you alone, the engineering team in standup, or up the chain (e.g., your manager, an exec, a board)?
GUESS: engineering team in standup, because "we" usually scopes that way and standups are where this question gets asked. If it's for execs the metrics and the framing change a lot.

User: It's actually for me. I keep losing track of which experiments are running and what their early signal looks like.

Agent:
Updated read: not a team dashboard at all. It's a personal experiment tracker. Confidence: ~60% — still missing: what "early signal" means and what done looks like.

Q:     Is the gap that you don't know which experiments exist, or that you can't see their results in one place?
GUESS: the second one. You have a list of experiments somewhere, but their results live in five different tools, and reconciling them by hand is what you're tired of.

User: First one actually. I literally don't have a list. They're spread across different docs.

Agent: <continues interviewing, reaches 95%, user confirms>

Here's what I now think you want:

- Outcome:      A single list of all active experiments with their basic status
- User:         You, personally, tracking your own experiments
- Why now:      Experiments are spread across docs; you can't see them all at once
- Success:      You open one page and see every experiment and its current stage
- Constraint:   Must pull from existing docs; no new data entry workflows
- Out of scope: Analytics, team dashboards, metric visualizations, reporting

Confirmed.

Next: I recommend /spec-writing to turn this into a formal spec, then /plan to build it. Sound good?
User: yes
Agent: <invokes spec-writing with the confirmed intent as input>
```

Two questions in, the agent has discovered the actual ask isn't "a dashboard." It's "a list." Different artifact, different scope, different work. The dashboard would have been wrong. And after confirmation, the agent routes to `/spec-writing` instead of jumping to code.

## Interaction with Other Skills

**[HARD-GATE]** Interview-me is the entry point of the Define phase. After confirmation, you MUST route to a downstream skill. Never jump directly to implementation.

| Downstream skill | When to route | Relationship |
|---|---|---|
| `brainstorming` | Intent needs scoping or alternative approaches | Generate variations, then re-check intent |
| `spec-writing` | Intent is concrete with clear success criteria | Formalize intent as a JTBD spec with Given/When/Then |
| `planning` | After spec exists | Structured implementation plan from the spec |
| `task-decomposition` | After plan exists | Break plan into executable subtasks |

**Anti-pattern: skipping the chain.** The correct chain is:

```
interview-me → spec-writing → planning → task-decomposition → implementation
                ↑ (or brainstorming if scoping needed)
```

Any step skipped is a rework risk. Interview-me's job ends at routing — it does not produce specs, plans, or code.

## Common Rationalizations

| Rationalization                                           | Reality                                                                                                                                                                       |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "The ask is clear enough"                                 | If you can't write the user's desired outcome in one sentence right now, the ask isn't clear. Run Step 1 before deciding.                                                     |
| "Asking too many questions wastes their time"             | Time wasted by 4–6 targeted questions is small. Time wasted by building the wrong thing is enormous, and the user is the one bearing that cost.                               |
| "I'll figure it out as I build"                           | Switching costs after code exists are 10x what they are now. Discovery during implementation is rework.                                                                       |
| "They said 'whatever you think,' so I should just decide" | "Whatever you think" is delegation, not decision. Re-ask with two concrete options as a choice.                                                                               |
| "I should give them several options to pick from"         | Options work when the user knows what they want and is choosing between trade-offs. They don't know what they want yet. Listing options widens the search; asking narrows it. |
| "If I attach my guess, I'm leading them"                  | Leading is the point. Reacting is faster than generating from scratch. The risk is sycophancy, not leading; mitigate by being visibly willing to be wrong.                    |
| "We've talked enough, I get it"                           | Test it: can you predict their reaction to the next three questions? If not, you don't get it yet.                                                                            |
| "The user said yes, we're done"                           | If the yes followed a vague restate or an open-ended "sounds good," the yes is hollow. Restate concretely and re-confirm.                                                     |
| "The user confirmed the restate, let me start building"   | Confirmation is not a green light for code. It's a green light for the next Define-phase skill. Route to `/spec-writing` or `/brainstorming` — never skip to implementation.  |
| "The intent is simple, we don't need a spec"              | Simple intents still benefit from spec-writing to surface edge cases and acceptance criteria you haven't thought of. If it's truly trivial, interview-me shouldn't have been invoked. |

## Red Flags

- Three or more questions in a single message: that's batching, not interviewing
- A question without your hypothesis attached: that's surveying, not committing
- Accepting "whatever you think is best" as a terminal answer
- Producing a spec, plan, or task list before the user has explicitly confirmed your restate
- Questions framed as "what would be best practice?" instead of "what do you actually want?"
- The user gives a sophistication-signaling answer ("scalable", "clean", "modern") and you accept it without probing whether it's what they actually want
- Three or more rounds without your confidence visibly rising: you're asking the wrong questions, step back and reframe
- A confidence number below ~70% with no reason attached: the user can't help close the gap if they don't know what's missing
- Saving the intent doc before the user has confirmed (the doc itself implies a yes the user didn't give)
- Skipping the "Out of scope" line in the restate (silent disagreement about non-goals is half of misalignment)
- Jumping to code, library suggestions, or file scaffolding after confirmation without routing to a downstream skill — this is the single most common failure mode after a successful interview
- Asking "want me to start coding?" or "ready to build?" after confirmation — you already know the answer; route instead

## Verification

After applying interview-me:

- [ ] An explicit hypothesis with a confidence number was stated in the first turn
- [ ] Every confidence number below ~70% was accompanied by a one-line reason (what's still unresolved or missing)
- [ ] Questions were asked one at a time, each with the agent's guess attached
- [ ] At least one "what would you actually want if you didn't have to justify it?" probe ran when the user gave a sophistication-signaling or convention-signaling answer
- [ ] A concrete restate (Outcome / User / Why now / Success / Constraint / Out of scope) was written back to the user
- [ ] The user confirmed the restate with an explicit yes (not "whatever you think," not "sounds good," not silence)
- [ ] At the stop point, the agent could predict reactions to the next three questions it would ask
- [ ] **[HARD-GATE]** After confirmation, the agent explicitly recommended a downstream skill (`/spec-writing`, `/brainstorming`) and did NOT jump to code, libraries, or implementation
- [ ] The routing recommendation matched the intent characteristic (concrete → spec-writing, needs scoping → brainstorming)
- [ ] Any handoff to a downstream skill was framed in terms of the confirmed intent, not the original underspecified ask
