//
//  ContentView.swift
//  DiceRoll
//
//  Created by Daria Yatsyniuk on 30.07.2025.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var diceAmount = 1
    @State private var diceSides = 4
    @State private var result = 0
    @State private var individualRolls: [Int] = []

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

            VStack() {
                Text("Your result is: \(result)")
                if !individualRolls.isEmpty {
                    Text("Rolls: \(individualRolls.map { String($0) }.joined(separator: ", "))")
                } else {
                    Text("")
                }
            }


            Button("Tap to Roll!") {
                diceRoll(sides: diceSides, dices: diceAmount)
            }
            .buttonStyle(.borderedProminent)
            .font(.title)
            .padding()
        }
    }

    func diceRoll(sides: Int, dices: Int) {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()

        var total = 0
        var rolls: [Int] = []
        for _ in 1...dices {
            let roll = Int.random(in: 1...sides)
            rolls.append(roll)
            total += roll
        }
        result = total
        individualRolls = rolls

        impact.impactOccurred()
    }
}

#Preview {
    ContentView()
}
