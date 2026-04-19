Get up to speed on the current branch's changes (committed, staged, and untracked):

1. Run `git log main..HEAD --format="%h %s"` to see commit history
2. Run `git diff main...HEAD` to see all committed changes since branch diverged
3. Run `git status` to see staged, unstaged, and untracked files
4. Run `git diff` to see unstaged changes
5. Read any new untracked files to understand their purpose
6. Internalize all changes silently - do NOT prompt the user or ask questions
7. Provide a brief summary of what the branch does and its current state, then wait for the user's next request
