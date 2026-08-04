# Pi Coding Agent (pi)

Installs the [Pi coding agent](https://github.com/earendil-works/pi) globally from npm. The Feature also installs the latest LTS release of Node.js through the official Node Feature.

## Example Usage

```json
"features": {
    "ghcr.io/igor-makarov/pi-devcontainer/pi:1": {}
}
```

To pin Pi to a specific npm release:

```json
"features": {
    "ghcr.io/igor-makarov/pi-devcontainer/pi:1": {
        "version": "0.82.1"
    }
}
```

## Options

| Option | Description | Type | Default |
|---|---|---|---|
| `version` | npm version or dist-tag of `@earendil-works/pi-coding-agent` to install | string | `latest` |
| `settings` | JSON object string written to `~/.pi/agent/settings.json` for the remote user | string | empty |

Dev Container Feature options only support string and boolean values, so the settings object must be JSON-encoded as a string:

```json
"features": {
    "ghcr.io/igor-makarov/pi-devcontainer/pi:1": {
        "settings": "{\"defaultProvider\":\"anthropic\",\"defaultThinkingLevel\":\"high\",\"enableInstallTelemetry\":false}"
    }
}
```

The Feature validates that `settings` contains a JSON object and replaces the remote user's global Pi settings file. Do not put API keys or other secrets in this option because Feature options are part of the container build configuration. Use Dev Container or Codespaces secrets instead.
