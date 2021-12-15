import { v4 as uuidv4 } from "uuid"

export const id = uuidv4()

export const addTwoNumbers = (number_1: number, number_2: number): number => {
    return number_1 + number_2
}