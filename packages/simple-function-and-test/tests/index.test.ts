import { addTwoNumbers } from "../utils/addTwoNumbers.ts";
import assert from "node:assert/strict";
import { it } from "node:test";
import { multiplyTwoNumbers } from "../utils/multiplyTwoNumbers.ts";

// oxlint-disable-next-line no-floating-promises
it("addTwoNumbers(5, 10) should return 15", () => {
  const result = addTwoNumbers(5, 10);
  assert.strictEqual(result, 15);
});

// oxlint-disable-next-line no-floating-promises
it("multiplyTwoNumbers(5, 10) should return 50", () => {
  const result = multiplyTwoNumbers(5, 10);
  assert.strictEqual(result, 50);
});
