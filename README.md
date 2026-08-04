# Pi Dev Container Feature

A [Dev Container Feature](https://containers.dev/implementors/features/) that installs the [Pi coding agent](https://github.com/earendil-works/pi) globally with npm.

## Usage

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/igor-makarov/pi-devcontainer/pi:1": {}
    }
}
```

The Feature depends on the official Node.js Feature and installs the latest LTS version of Node.js. After the container is built, run:

```sh
pi
```

## Options

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

## Development

Install the locked Node.js and [Dev Container CLI](https://github.com/devcontainers/cli) toolchain with [mise](https://mise.jdx.dev/):

```sh
mise install --locked
```

Then validate and test the Feature:

```sh
devcontainer features test --project-folder . --features pi
```

The workflows in `.github/workflows/` validate, test, and publish the Feature to GHCR. Documentation is maintained manually in this repository.
