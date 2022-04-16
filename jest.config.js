/** @type {import('ts-jest/dist/types').InitialOptionsTsJest} */

export default {
    extensionsToTreatAsEsm: [".ts"],
    globals: {
      "ts-jest": {
        "useESM": true
      }
    },
    moduleNameMapper: {
      "(.+)\\.js": "$1"
    },
    preset: "ts-jest",
    testEnvironment: "node",
    transform: {
      "\\.[jt]sx?$": "ts-jest",
    },
  }
  
