Review PR comments from Copilot or chatgpt-codex-connector and provide your own assessment of each.

The user will provide JSON output from `gh api` containing PR review comments. This is the argument: $ARGUMENTS

## Instructions

1. Parse the JSON array of PR review comments
2. Filter to only comments where `user.login` is `"Copilot"`
3. For each Copilot comment, produce a review entry containing:
   - **File**: the `path` and `line` number
   - **Copilot says**: a brief summary of the comment's `body`
   - **Suggestion**: show the code suggestion if one exists (inside a ```suggestion block in the body)
   - **Verdict**: state whether you **Agree** or **Disagree**
   - **Reasoning**: explain why you agree or disagree, referencing the actual code in the diff_hunk and the project's conventions from CLAUDE.md/AGENTS.md

4. When evaluating, consider:
   - Is the suggestion actually correct for CakePHP 2.x conventions?
   - Does it align with this project's established patterns?
   - Is it a meaningful improvement or just noise?
   - Read the actual source file if needed to understand full context

5. After all comments, provide a summary: "X of Y Copilot suggestions worth addressing"

## Output Format

For each comment:

### [n]. `path/to/file.php:LINE`

**Copilot says:** [summary]

**Suggestion:**
```
[code if any]
```

**Verdict:** Agree / Disagree

**Reasoning:** [explanation]

---

## Summary

**X of Y Copilot suggestions worth addressing.**
