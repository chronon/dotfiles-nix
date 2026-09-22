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
