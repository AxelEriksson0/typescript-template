# TypeScript template

This repository started out as a simple opinionated tsconfig.json template. Apparently there was a lot of things to be opinionated about so now this template is a monster with setups for EsLint, testing, package manager, CI/CD, web and more. I'm not sure if it's a good thing.

## Packages

### Simple function and test

Contains a simple function and unit testing to go with it.

### [Traefik infrastructure](./traefik-infrastructure/README.md)

See separate README.

### Web

Web infrastructure project with SolidJS, Ark UI for components and Panda CSS for styling.

## Structure

- Using ESLint's new configuration system - https://eslint.org/docs/latest/use/configure/configuration-files-new
- Using Yarn as it simplifies adding arguments when running scripts.
- ESM (requires TypeScript 4.7.0+)

### fnm

`fnm` is used and configured to automatically read the `.node-version` file and set the correct `node` version. See https://github.com/Schniz/fnm for more information.

### npm-check-updates

`npm-check-updates` helps automatically updating the dependencies in the project. Will most likely not be used in a real project because they can be very sensitive to updating dependencies, even minor ones.

### jiti

Jiti is required for `eslint` to function.
