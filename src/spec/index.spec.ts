import { addTwoNumbers } from "../utils/addTwoNumbers.js"
import { multiplyTwoNumbers } from "../utils/multiplyTwoNumbers.js"

describe("Mathematical operations", () => {

  test("addTwoNumbers(5, 10) should return 15", () => {
    const result = addTwoNumbers(5, 10)
    expect(result).toBe(15)
  })

  test("multiplyTwoNumbers(5, 10) should return 50", () => {
    const result = multiplyTwoNumbers(5, 10)
    expect(result).toBe(50)
  })

})
