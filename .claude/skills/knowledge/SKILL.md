---
name: knowledge
description: Write or update KNOWLEDGE.md at the repo root, a plain-language explanation of the code, the architecture and every decision, so the user can understand it and explain it in a demo. Called by /sprint after each slice and by /wrap at the end. Also use when the user says "explain what we built", "update the knowledge file", or "prep me for the demo".
argument-hint: "[draft | update | final]"
---

# /knowledge — understanding, written down

Mode: $ARGUMENTS (empty = `update`).

The user has about 90 minutes and must be able to **explain this system in a demo**. KNOWLEDGE.md is for a smart person who did not write the code and has never seen this repo. Understanding beats completeness.

## Modes
- **draft** (after Frame, from `SPRINT.md` and what you learned in Orient): write §1–§4 and §7 as *planned*. Mark anything not built yet with `(planned)`.
- **update** (after each slice): change what is now true. Move items from `(planned)` to built, add the `path:line` for what exists, add any new decision, fix anything that turned out different from the plan.
- **final** (in `/wrap`): make every section true to the final code, delete or label what was cut, add §8 (demo script and likely questions).

## The file (create it if missing, update in place if it exists)

```
# <Project>: what it is and how it works
_Last updated: <HH:MM> · slice <n> of <m> · written for the demo_

## 1. The one-minute pitch
<Say-it-out-loud version: the problem, what we built, how it works, why it's a good approach. 5-6 sentences, no jargon.>

## 2. The problem, and what the repo already did
<What was given. What was missing or broken. In plain words.>

## 3. The architecture
<ASCII diagram of the main pieces and how data flows between them.>
<Then: each piece in 1-2 sentences: what it does, where it lives (`path`), and whether it is plain code or a model call (if any).>

## 4. How one request flows, end to end
<One concrete example, input → each step → output, with `path:line` for every step.>

## 5. The decisions we made
For each decision:
### <Decision in plain words>
- **We chose:** <choice>
- **Why:** <the reason, in plain words, tied to this problem's constraints>
- **We could have:** <the main alternative, and when it would be better>
- **If asked "why not X?":** <a two-sentence answer the user can say aloud>
- **Rule behind it:** <architecture-reviewer ID such as P10, if one applies, plus what it means in plain words>

## 6. What we did NOT build, and what could go wrong
<The cut list, each with why it was cut. Known limits and weak spots, stated honestly.>

## 7. Where things are
| To understand… | Read |
|---|---|
| <topic> | `path` |

## 8. Demo (final mode only)
**Two-minute walkthrough:** <numbered steps: what to show, what to say>
**Questions you'll likely get:** <8-10 questions with short answers, including the hard ones: limits, scale, alternatives, what you'd do next>

## Glossary
- **<term>**: <one-line meaning>
```

## Rules
- **Plain language.** Short sentences. Define every technical term the first time it appears, or put it in the glossary. Use an analogy when it genuinely helps.
- **True to the code.** Every claim about what the code does comes from code you read, with `path:line`. If a part is unbuilt or unknown, say `(planned)` or `unknown`. Never describe what you hope the code does.
- **Honest.** Say what is weak or cut. A demo audience trusts a system whose limits are stated.
- **Keep it readable in 10 minutes.** About 2-3 pages. Cut detail before cutting clarity.
- **Decisions come from `SPRINT.md` and the real conversation.** Do not invent a reason. If the reason was "time", write "time".
- Never put secrets in it.

## After writing (all modes except final)
Tell the user in chat, in 3 plain bullets, **what they should now understand** from this slice (what was built, why this way, one thing to be able to say in the demo). Keep it under 60 words. Do not paste the file.
