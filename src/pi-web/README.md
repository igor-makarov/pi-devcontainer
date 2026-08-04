# Pi Web (pi-web)

Installs [Pi Web](https://github.com/ashwin-pc/pi-web) from the `main` branch on GitHub using npm. The Feature builds the web frontend and starts `pi-web` whenever the container starts.

## Example Usage

```json
{
    "features": {
        "ghcr.io/igor-makarov/pi-devcontainer/pi-web:1": {}
    },
    "forwardPorts": [
        8787
    ],
    "portsAttributes": {
        "8787": {
            "label": "Pi Web"
        }
    }
}
```

Dev Container Features cannot declare forwarded ports themselves, so port 8787 must be forwarded by the consuming `devcontainer.json`. After the container starts, open the forwarded **Pi Web** port or visit `http://localhost:8787`.

Server output is written to `/tmp/dev-server.log`.

## Configuration

Pi Web uses its standard environment variables, including `PI_WEB_TOKEN` and `PI_WEB_CWD`. See the [Pi Web documentation](https://github.com/ashwin-pc/pi-web#environment-variables) for details.
