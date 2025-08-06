//
//  DiceRoll.swift
//  DiceRoll
//
//  Created by Daria Yatsyniuk on 05.08.2025.
//
import SwiftData
import Foundation

@Model
class DiceRoll {
    var timestamp: Date
    var diceAmount: Int
    var diceSides: Int
    var total: Int
    var individualRolls: [Int] = []

    init(timestamp: Date = Date(), diceAmount: Int, diceSides: Int, total: Int, individualRolls: [Int]) {
        self.timestamp = timestamp
        self.diceAmount = diceAmount
        self.diceSides = diceSides
        self.total = total
        self.individualRolls = individualRolls
    }
}
