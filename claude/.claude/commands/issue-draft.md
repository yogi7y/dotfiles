# Issue Draft

Generate a Product Requirements Document (PRD) for: $ARGUMENTS

## Process:

1. **Understand the Requirement**

   - If it's a GitHub issue number, fetch details using `gh issue view`
   - Otherwise, parse the text requirement provided
   - Research the codebase to understand relevant context

2. **Generate PRD** with the following sections:

   ### Problem

   - What user problem are we solving?
   - Why is this important?

   ### Solution

   - Brief description of what we're building
   - Key features or capabilities

   ### User Stories

   - As a [type of user], I want [goal] so that [benefit]
   - Include 2-4 key user stories

   ### Acceptance Criteria

   - Clear, testable conditions for completion
   - Checklist format
   - Focus on user-visible outcomes

   ### Edge Cases & Open Questions

   - User scenarios that need consideration
   - Ambiguities or assumptions to validate
   - What's explicitly out of scope

3. Share the PRD in a markdown format and ask if all good. Once confirmed, create a new issue on GitHub.

## Important Notes:

- Focus on WHAT needs to be built, not HOW
- Write from the user's perspective
- Keep it concise and actionable
- Research is for context only - don't include technical details in PRD
