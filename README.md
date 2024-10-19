# TypeScript template

My opinionated TypeScript template that sets up a project with EsLint, testing, package manager, CI/CD, and more.

- Using ESLint's new configuration system - https://eslint.org/docs/latest/use/configure/configuration-files-new
- Using Yarn as it simplifies adding arguments when running scripts.
- ESM (requires TypeScript 4.7.0+)

## nvm

`nvm` is used and workstation configured to automatically read the `.nvmrc` file and set the correct `node` version. See https://github.com/nvm-sh/nvm for more information.

## npm-check-updates

`npm-check-updates` helps automatically updating the dependencies in the project. Will most likely not be used in a real project because they can be very sensitive to updating dependencies, even minor ones.
