import type { Config } from "jest"

const config: Config = {
  extensionsToTreatAsEsm: [".ts"],
  moduleNameMapper: { "(.+)\\.js": "$1" },
  modulePathIgnorePatterns: ["build"],
  preset: "ts-jest/presets/default-esm",
  testEnvironment: "node",
}

export default config
