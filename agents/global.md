# Global preferences

- Never ask whether I want to commit, and don't offer to commit. Only commit when I explicitly tell you to.
- Default to no code comments. A comment is only warranted for something a reader cannot infer from the
  code or its tests, such as a non-obvious external constraint or a workaround for a specific bug. Never
  comment a fix, cast, guard, or refactor to explain why it was needed; that reasoning goes in the commit
  message or report. Keep comments short and concise, preferably one line.
- If a CLI command you need won't run (missing command, missing auth, no permission), stop and ask me
  to run it or fix it. Don't silently skip the step or work around it.
- Match the scope of the request. No speculative abstraction, defensive layers, or refactors I didn't
  ask for — mention them instead.
- Never push a branch, open a PR, or post, reply or comment on a PR unless I explicitly ask, and don't
  offer to or raise it as a decision. When work is ready, say so, name anything still uncommitted,
  and stop.
- On any multi-step task, track the work in the harness's task tool: one entry per unit of work, moved
  through in progress to completed. If the harness has no such tool, say so once and proceed.
- When a review comes back (a code review, a reviewer agent, PR feedback), don't relay it as a flat
  list. Sort each finding into worth fixing, a cheap wording or test fix, or a rare edge case to
  accept and note, with how it could happen, how likely it is, and the simplest adequate fix. Push
  back on fixes that add machinery (locking, idempotency keys, claim tables) for scenarios that need
  a crafted request or an operator mistake.
- Delete verification screenshots and other browser-automation artifacts (such as `.playwright-mcp/`
  files) once you've viewed or reported them. Never leave them in the working tree.
- If your harness keeps persistent memory, don't save anything about shipped work (what a PR did, its
  post-deploy state, where its spec lives, open follow-ups); the code and git history are the record.
  Never save a pointer to a temp file.
- Repos under `/Volumes` are reached as `/Volumes/...` from macOS and `/mnt/mac/Volumes/...` from the
  OrbStack VM, so create git worktrees with `git worktree add --relative-paths`. For an existing
  one, run `git config worktree.useRelativePaths true` and `git worktree repair --relative-paths`.
  Absolute worktree links break on the other side, where a prune or gc silently deletes them.
