import { addTwoNumbers } from "../index"

describe('addTwoNumbers', () => {

    it('addTwoNumbers(5, 10) should return 15', () => {
        const result = addTwoNumbers(5, 10)
        if (result !== 15) {
            throw Error('Result was not 15, waiting for expect')
        }
    })

})