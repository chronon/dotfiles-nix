---
name: catchup
description: Get up to speed on changes — reads the current branch's commits, diffs, and untracked files, or a single commit if one is named, then summarizes what changed. Use when the user asks to catch up, or what changed on this branch or in a given commit.
argument-hint: "[commit-hash]"
---

Get up to speed on changes. If the user named a specific commit (in Claude Code this arrives as `$ARGUMENTS`; otherwise take the hash from their message), follow **If a commit was named**. If they named nothing, follow **If no commit was named**.

## If no commit was named

Catch up on the current branch's changes (committed, staged, and untracked):

1. Run `git log main..HEAD --format="%h %s"` to see commit history
2. Run `git diff main...HEAD` to see all committed changes since branch diverged
3. Run `git status` to see staged, unstaged, and untracked files
4. Run `git diff` to see unstaged changes
5. Read any new untracked files to understand their purpose
6. Internalize all changes silently - do NOT prompt the user or ask questions
7. Provide a brief summary of what the branch does and its current state, then wait for the user's next request

## If a commit was named

Catch up on the given commit (`$ARGUMENTS` in Claude Code — substitute the hash the user gave you):

1. Run `git show --no-patch --format="%h %s%n%P" <hash>` to read the subject and parent hashes
2. Count the parents (space-separated on the second line):
   - **1 parent** = regular commit. Run `git show <hash>` to see the full diff
   - **2+ parents** = merge commit. Run `git log <first-parent>..<second-parent> --format="%h %s"` to list the merged commits, then `git diff <first-parent>...<second-parent>` to see the combined diff. Optionally run `git show <hash>` on individual merged commits if more detail is needed
3. Internalize all changes silently - do NOT prompt the user or ask questions
4. Provide a brief summary of what the commit (or merged branch) does, then wait for the user's next request
