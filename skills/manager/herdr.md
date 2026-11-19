# Manager on Herdr

The Herdr commands for each step of the manager skill. Read the Herdr skill in the sibling `herdr/`
directory of this skill and follow it for every Herdr command.

## Preflight

```bash
test "${HERDR_ENV:-}" = 1
```

## Start a worker

Each worker gets its own tab in the current workspace, in the current working directory, without
taking focus. Label the tab with a short task name so the user can find it:

```bash
herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label "<short task>" --no-focus
```

Read the root pane from `.result.root_pane`, then start the agent in that pane:

```bash
herdr agent start <name> --kind <kind> --pane <root-pane-id>            # default model
herdr agent start <name> --kind <kind> --pane <root-pane-id> -- --model <model-id>
```

Wait for `idle` before prompting.

## Prompt and wait

```bash
herdr agent prompt <name> "<prompt>" --wait --timeout <ms>
```

Run this, and any other blocking wait (`agent wait`, `pane wait-output`), as a background command.
On `timeout`, inspect with `agent get` and `agent read` before deciding whether to keep waiting.

## Blocked worker

A wait that returns `blocked` means the worker is on an approval or question prompt. Read its
screen with `agent read`, and once the user decides, relay their answer with `agent send-keys` or
`agent prompt`.

## Correct a working worker

`herdr agent prompt <name> "<correction>"` without `--wait`; the background wait already running
covers it. When that wait returns, check `agent get`; if the worker is working again, wait again in
the background.

## Read a worker

`agent read` shows the worker's screen when it returned no report path.

## Parallel editors

Put each editing worker in its own Herdr worktree. A Herdr worktree already has its own branch.

## Close a worker

Close the worker's tab. Name tabs to the user by their label; IDs such as `w1:t3` are for `herdr`
commands only.
