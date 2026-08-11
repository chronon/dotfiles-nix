# Global preferences

- Never ask whether I want to commit, and don't offer to commit. Only commit when I explicitly tell you to.
- Only add a code comment when the code can't convey it on its own, and keep it short. This applies
  equally to review and follow-up fixes — don't comment a change just because it was a fix.
- If a CLI command you need won't run (missing command, missing auth, no permission), stop and ask me
  to run it or fix it. Don't silently skip the step or work around it.
- Match the scope of the request. No speculative abstraction, defensive layers, or refactors I didn't
  ask for — mention them instead.
