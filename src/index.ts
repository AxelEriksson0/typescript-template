import { v4 as uuidv4 } from "uuid"

import { addTwoNumbers } from "./utils/addTwoNumbers.js"

export const id = uuidv4()

console.log(addTwoNumbers(1, 2))
