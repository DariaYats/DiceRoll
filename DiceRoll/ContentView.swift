//
//  ContentView.swift
//  DiceRoll
//
//  Created by Daria Yatsyniuk on 30.07.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var diceAmount = 1
    @State private var diceSides = 4
    @State private var result = 0
    @State private var individualRools: [Int] = []

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Stepper("Number of dice sides: \(diceSides)", value: $diceSides, in: 4...Int.max)
            }
            .padding()


            VStack(spacing: 10) {
                Stepper("Number of dices: \(diceAmount)", value: $diceAmount, in: 1...Int.max)
            }
            .padding()

            Text("Your result is \(result)")
            if !individualRools.isEmpty {
                Text("Rolls: \(individualRools.map { String($0) }.joined(separator: ", "))")
            }

            Button("Roll the dice") {
                diceRoll(sides: diceSides, dices: diceAmount)
            }
        }
    }

    func diceRoll(sides: Int, dices: Int) {
        var total = 0
        var rolls: [Int] = []
        for dice in 1...dices {
            let roll = Int.random(in: 1...sides)
            rolls.append(roll)
            total += roll
        }
        result = total
        individualRools = rolls
    }
}

#Preview {
    ContentView()
}
