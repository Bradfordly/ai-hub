# Cloud sessions bootstrap through the environment setup script

Claude Code cloud sessions don't install plugins that a repo declares under `enabledPlugins` or `extraKnownMarketplaces`. They also don't read the user's `~/.claude/` from the developer's machine. They do run the cloud environment's setup script before Claude launches, and they cache the resulting filesystem.

So the supported cloud path is a setup script that clones ai-hub and runs `scripts/bootstrap.sh`, which installs the plugin and its `mattpocock-skills` dependency into the session's user scope. If plugin installation is unavailable in that environment, the script falls back to symlinking into `~/.claude/{agents,skills}`.

Consumer repos still commit `enabledPlugins` for local and headless `claude -p` runs, where it does apply.

**Revisit** if cloud sessions start honoring repo-declared plugins.
