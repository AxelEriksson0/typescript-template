import { addTwoNumbers } from "../utils/addTwoNumbers.js"

describe("addTwoNumbers", () => {

    test("addTwoNumbers(5, 10) should return 15", () => {
        const result = addTwoNumbers(5, 10)
        if (result !== 15) {
            throw Error("Result was not 15, waiting for expect")
        }
    })

})
