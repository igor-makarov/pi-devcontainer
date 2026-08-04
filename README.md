# Pi Dev Container Features

Dev Container Features for the [Pi coding agent](https://github.com/earendil-works/pi) and [Pi Web](https://github.com/ashwin-pc/pi-web).

## Pi

Installs the Pi coding agent globally from npm.

```jsonc
"features": {
    "ghcr.io/igor-makarov/pi-devcontainer/pi:1": {}
}
```

The Feature depends on the official Node.js Feature and installs the latest LTS release of Node.js. After the container is built, run:

```sh
pi
```

### Options

| Option | Description | Default |
|---|---|---|
| `version` | npm version or dist-tag of `@earendil-works/pi-coding-agent` | `latest` |

For example, to pin a release:

```jsonc
"features": {
    "ghcr.io/igor-makarov/pi-devcontainer/pi:1": {
        "version": "0.82.1"
    }
}
```

## Pi Web

Installs Pi Web from the `main` branch on GitHub using npm and starts it whenever the container starts.

```jsonc
{
    "features": {
        "ghcr.io/igor-makarov/pi-devcontainer/pi-web:1": {}
    },
    "forwardPorts": [8787],
    "portsAttributes": {
        "8787": {
            "label": "Pi Web"
        }
    }
}
```

Features cannot declare forwarded ports themselves, so port 8787 must be configured in the consuming `devcontainer.json`. Server output is written to `/tmp/dev-server.log`.

## Development

Install the locked Node.js and [Dev Container CLI](https://github.com/devcontainers/cli) toolchain with [mise](https://mise.jdx.dev/):

```sh
mise install --locked
```

Then validate and test the Features:

```sh
devcontainer features test --project-folder .
```

The workflows in `.github/workflows/` validate, test, and publish the Features to GHCR. Documentation is maintained manually in this repository.
