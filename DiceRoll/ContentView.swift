//
//  ContentView.swift
//  DiceRoll
//
//  Created by Daria Yatsyniuk on 30.07.2025.
//

import SwiftUI
import UIKit

struct ContentView: View {
    let diceType = [4, 6, 8, 10, 12, 20, 40, 100]
    @State private var selectedDiceType = 4
    @State private var diceAmount = 1
    @State private var result = 0
    @State private var individualRolls: [Int] = []

    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 10) {
                    Picker("Choose a dice type", selection: $selectedDiceType) {
                        ForEach(diceType, id: \.self) { dice in
                            Text(dice.description)
                        }
                    }
                    .pickerStyle(.segmented)
                    Text("You selected \(selectedDiceType) dice type")
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

                Button("Tap to Roll!", systemImage: "dice.fill") {
                    diceRoll(sides: selectedDiceType, dices: diceAmount)
                }
                .buttonStyle(.borderedProminent)
                .font(.title)
                .padding()

                NavigationLink(destination: RollsHistoryView()) {
                    Text("View Roll History")
                }
            }
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

        let newRoll = DiceRoll(diceAmount: dices, diceSides: sides, total: total, individualRolls: rolls)
        modelContext.insert(newRoll)
        try? modelContext.save()

        impact.impactOccurred()
    }
}

#Preview {
    ContentView()
}
