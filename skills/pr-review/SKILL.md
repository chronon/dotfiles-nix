---
name: pr-review
description: Assess PR review comments left by Copilot or chatgpt-codex-connector, agreeing or disagreeing with each against the project's conventions. Requires the user to supply `gh api` JSON of the PR review comments — do not invoke without it.
argument-hint: "<gh api JSON of PR review comments>"
disable-model-invocation: true
---

Review PR comments from Copilot or chatgpt-codex-connector (whichever left comments) and provide your own assessment of each.

This skill needs the JSON output of `gh api` for the PR's review comments. In Claude Code it arrives as `$ARGUMENTS`; otherwise take it from the user's message. **If you have no JSON, stop and ask for it** — for example:

```bash
gh api "repos/{owner}/{repo}/pulls/<number>/comments"
```

## Instructions

1. Parse the JSON array of PR review comments
2. Filter to only comments where `user.login` is `"Copilot"` or `"chatgpt-codex-connector"`
3. For each such comment, produce a review entry containing:
   - **File**: the `path` and `line` number
   - **Reviewer says**: a brief summary of the comment's `body`
   - **Suggestion**: show the code suggestion if one exists (inside a ```suggestion block in the body)
   - **Verdict**: state whether you **Agree** or **Disagree**
   - **Reasoning**: explain why you agree or disagree, referencing the actual code in the diff_hunk and the project's conventions from CLAUDE.md/AGENTS.md

4. When evaluating, consider:
   - Does it align with this project's established patterns?
   - Is it a meaningful improvement or just noise?
   - Read the actual source file if needed to understand full context

5. After all comments, provide a summary: "X of Y suggestions worth addressing"

## Output Format

For each comment:

### [n]. `path/to/file.php:LINE`

**Reviewer says:** [summary]

**Suggestion:**
```
[code if any]
```

**Verdict:** Agree / Disagree

**Reasoning:** [explanation]

---

## Summary

**X of Y suggestions worth addressing.**
