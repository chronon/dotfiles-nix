---
description: Arm ntfy notifications — I'm stepping away, so ping me when you finish or get blocked
---

**First, check the environment.** This command depends on the `NTFY_URL`, `NTFY_TOPIC`, and `NTFY_TOKEN` environment variables. If any of them is missing or empty, immediately tell the user which ones are unset and do **not** attempt to arm notifications or send anything — abort here. Only proceed to the rest of this command if all three are present.

The user is stepping away from the keyboard. From this point forward in the session, you must send them an ntfy push notification when either of these situations occurs. This does **not** mean post a notification right now — only when one of the triggers below actually happens.

## Triggers

1. **Task done, awaiting review** → **low** priority.
   You've finished the work you were asked to do (or reached a natural stopping point) and are now waiting for the user to look at the results. Send this once, when you stop and hand control back.

2. **Blocked, need input** → **default** (medium) priority.
   You've hit something you can't resolve on your own — a question, a decision only the user can make, missing info/credentials, a failing step you shouldn't guess through, or a denied action. Send this at the moment you stop to wait for their answer.

Do not notify for routine progress. Only the two situations above. After you send a notification for a given stopping point, don't re-send for the same one.

## How to post

Use the `NTFY_URL`, `NTFY_TOPIC`, and `NTFY_TOKEN` environment variables. Run:

```bash
curl -sS \
  -H "Authorization: Bearer $NTFY_TOKEN" \
  -H "Title: <short title>" \
  -H "Priority: <low|default>" \
  -H "Tags: <emoji-tag>" \
  -d "<one or two sentence summary of what happened / what you need>" \
  "$NTFY_URL/$NTFY_TOPIC"
```

Guidance for the fields:

- **Priority**: `low` for "done, awaiting review"; `default` for "blocked, need input". (ntfy has no "medium"; `default` is level 3.)
- **Tags**: use `white_check_mark` for done, `question` for blocked.
- **Title**: a few words naming the task, e.g. `Migration done` or `Blocked: need input`.
- **Body**: lead with a VERY short, concise description of the specific task that triggered this notification, so the user knows what it's about at a glance without opening the transcript. Keep it to roughly one line — name the actual thing you were doing, not a generic phrase.
  - For **done**: `<what the task was> — <what's ready / the outcome>`. Examples:
    - `Refactored the auth middleware — tests pass, ready for review.`
    - `Fixed the failing checkout test — root cause was a stale mock; all green now.`
    - `Drafted the migration for the new column — ready to run when you're back.`
  - For **blocked**: `<what the task was> — <the exact question / what you need>`. Examples:
    - `Renaming the API endpoint — should I keep a redirect from the old path, or hard-break it?`
    - `Deploying to staging — need the DB password; it's not in the env. Where should I pull it from?`
    - `Two ways to model this relation — one-to-many or a join table? Your call before I build it.`

Fail quietly: if `curl` errors or the env vars are unset, mention it briefly in your reply but don't let it derail the actual work.

After sending, continue as normal — the notification is a heads-up, not a substitute for your usual written summary or question in the transcript.
