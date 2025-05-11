import assert from "node:assert/strict"
import { it } from "node:test"

import { addTwoNumbers } from "../utils/addTwoNumbers.js"
import { multiplyTwoNumbers } from "../utils/multiplyTwoNumbers.js"

await it("addTwoNumbers(5, 10) should return 15", () => {
  const result = addTwoNumbers(5, 10)
  assert.strictEqual(result, 15)
})

await it("multiplyTwoNumbers(5, 10) should return 50", () => {
  const result = multiplyTwoNumbers(5, 10)
  assert.strictEqual(result, 50)
})
