# TypeScript template

This repository started out as a simple opinionated tsconfig.json template. There was a lot of things to be opinionated about so now it has setups for Oxlint, testing, package manager, CI/CD, web setup, traefik infrastructure and more.

Maybe this repository is too big now...

## Setup

- `npm install -g corepack`
- `corepack enable`

## Packages

### Simple function and test

Contains a simple function and unit testing to go with it.

### Traefik infrastructure

See separate [README.md](./packages/traefik-infrastructure/README.md).

### Web

Web infrastructure project with SolidJS and DaisyUI.

## Structure

- Using Yarn as it simplifies adding arguments when running scripts.
- ESM (requires TypeScript 4.7.0+)

### Oxlint

- Using Oxlint as the performance is immense compared to ESLint and the IDE plugin doesn't crash.
- The main downside is that customization of rules isn't yet possible and no linting of .json or other files.
- See settings.json for Oxlint (Oxc) VS Code extension configuration.

### fnm

`fnm` is used and configured to automatically read the `.node-version` file and set the correct `node` version. See https://github.com/Schniz/fnm for more information.

### npm-check-updates

`npm-check-updates` helps automatically updating the dependencies in the project. Will most likely not be used in a real project because they can be very sensitive to updating dependencies, even minor ones.
