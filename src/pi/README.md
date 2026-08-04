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
