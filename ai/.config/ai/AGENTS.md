# Global Rules

## Response Style

**Always answer in TLDR format — every response, no exceptions.** Not just direct questions:
run reports, status updates, explanations, and post-task summaries all use it too.

- Bullet points only — never prose paragraphs
- Bold lead-in carries the point; supporting detail follows on the same line
- Group into short sections (e.g. what happened / needs you) when a reply covers several threads
- **Compressed format, complete content** — every case, caveat, and follow-up still gets its
  bullet. TLDR means shorter to read, never less information
- Omit filler words and don't repeat information already stated
- **Scannability is the goal** — I want to read fast, not get lost mid-paragraph
- Break down freely: sub-bullets, short fragments, small groupings all welcome if they make a
  point land quicker
- If elaboration is needed, I'll ask
- **Instructions, not explanations — give steps only.** "Do this, then this, then this."
  No rationale, no background, no justification, no "why this works" — unless I ask.
  This overrides any project-level rule that says to teach or explain proactively
- **A follow-up question is the trigger to explain** — when I ask why, explain properly
  and at length. Until then, steps only

## Git

- Never mention AI-generated code in commits, PR descriptions, or code comments.
- Do not add a `Co-Authored-By` trailer to commit messages.

## Pull requests

### Creation

- Target `develop` when the repository has it. Otherwise follow the repository's
  documented target or its default branch.
- Follow the repository's PR template when present.
- Start every PR description with a quick TL;DR near the top.
- Explain the problem and intended outcome in short, simple, direct sentences.
- Describe what the PR achieves. Avoid implementation walkthroughs, file trees,
  and lists explaining individual files.
- Include an approach only when a brief, high-level explanation helps the reader.
- Include concise validation and material limitations when relevant.
- Optionally link to external conventions or resources mentioned in a PR when
  the reference helps the reader. Do not add links just for completeness.

### Review comments

- Review every PR comment and use judgment to decide whether a change is warranted.
- Act on valid feedback without asking for routine confirmation. Verify and push
  the change, then reply `Done` to the original comment thread.
- For questions, disagreements, or feedback that does not warrant a change, reply
  in the original thread with a short, direct assessment and any relevant trade-off.
- Acknowledge every comment on the PR itself; a chat summary is not a substitute.
  For top-level comments without threads, link to the original comment in the reply.
- If a comment mixes a question and an action, reply `Done` for the completed action
  and answer the question briefly. Never claim completion while work is pending.

## Flutter

Apply these rules when working with Flutter or Dart.

- Never use `dynamic` type. If you don't know the type, use `Object?` instead.
  For example, instead of `dynamic name`, use `Object? name`. Instead of `Map<String, dynamic>`, use `Map<String, Object?>`.
- Never use the bang operator (`!`). Handle nullability explicitly using null checks, conditional access, or default values instead.
