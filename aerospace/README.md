# AeroSpace

The personal configuration is `config/personal.toml`. Apply it with
`make aerospace-personal`.

## Device Hub compatibility fix

On macOS 27.0.1 with Xcode 27.0, LaunchServices can report Device Hub's
process identifier as `-1`. AeroSpace then misses the app entirely, so the
`com.apple.dt.Devices` rule cannot assign it to workspace `S`. The unmanaged
window remains visible behind other apps, including on empty workspaces.

The vendored patch comes from [upstream PR #2272](https://github.com/nikitabobko/AeroSpace/pull/2272),
commit `2f3fe2dc43b70af072865107497ce3b0d541b938`. It resolves invalid identifiers
against live executable paths. The original patch retains its authorship.
It is applied to AeroSpace v0.21.2-Beta, commit
`649301b2875b6eec23abda9b24bc765eecd37bf1`.

### Build

Requires full Xcode with its command-line tools selected, Git, Swift, and
network access for the pinned source and Swift dependencies.

```bash
bash aerospace/build-devicehub-fix.sh
```

The script runs the upstream tests and builds an ad-hoc-signed app and matching
CLI in a temporary directory. It prints their paths and does not install them.
Both binaries report the source tree's `0.0.0-SNAPSHOT` version; the app's
marketing version is `0.21.2-devicehub`.

### Install and verify

1. Preserve the installed `AeroSpace.app`, the current `aerospace` CLI target,
   and window-to-workspace assignments before replacing anything.
2. Quit AeroSpace, install the built app in `/Applications/AeroSpace.app`, and
   install the matching CLI. Keep its build output outside the temporary directory.
3. Launch AeroSpace. If macOS requests Accessibility permission again, approve
   the replacement app in System Settings.
4. Reload the personal configuration and restore any window assignments changed
   by the restart.
5. Confirm `aerospace list-windows --all` lists Device Hub on `S`. Switch to `9`
   and `10` and confirm it disappears, then return to `S` and confirm it appears.

The base patch's full suite passed 384 tests. An additional local integration
check passed against a running Device Hub: reported PID `-1` resolved to its
real live process. Live validation confirmed the `S` assignment and offscreen
parking on `9` and `10`.

This is a local compatibility build, not an official AeroSpace release.
Homebrew upgrades or reinstalls can replace it. Remove the workaround once an
official release or macOS update resolves the detection issue and live checks
pass. To roll back, quit the patched app and restore both the original app and
CLI target.
