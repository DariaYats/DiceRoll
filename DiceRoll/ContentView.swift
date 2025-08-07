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
    @State private var isRolling = false

    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.purple.opacity(0.3), .blue.opacity(0.2), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Select Dice Type")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)

                        Picker("Choose a dice type", selection: $selectedDiceType) {
                            ForEach(diceType, id: \.self) { dice in
                                Text(dice.description)
                                    .tag(dice)
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityHint("Select the number of sides for the dice.")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .shadow(radius: 4)
                    )
                    .padding(.horizontal)


                    VStack(spacing: 12) {
                        Text("Number of Dice")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                        Stepper("Dice: \(diceAmount)", value: $diceAmount, in: 1...100)
                            .accessibilityHint("Adjust the number of dice to roll.")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .shadow(radius: 4)
                    )
                    .padding(.horizontal)


                    VStack(spacing: 12) {
                        Text("Total: \(result)")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                            .scaleEffect(isRolling ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRolling)
                            .accessibilityLabel("Total result: \(result)")

                        if !individualRolls.isEmpty {
                            Text("Rolls: \(individualRolls.map { String($0) }.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .opacity(isRolling ? 0.7 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: isRolling)
                                .accessibilityLabel("Individual rolls: \(individualRolls.map { String($0) }.joined(separator: ", "))")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .shadow(radius: 4)
                    )
                    .padding(.horizontal)

                    Button("Tap to Roll!", systemImage: "dice.fill") {
                        withAnimation {
                            isRolling = true
                        }
                        diceRoll(sides: selectedDiceType, dices: diceAmount)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation{
                                isRolling = false
                            }
                        }
                    }
                    .font(.title2.weight(.semibold))
                    .padding()
                    .frame(maxWidth: 320)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .scaleEffect(isRolling ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRolling)


                    NavigationLink(destination: RollsHistoryView()) {
                        Text("View Roll History")
                    }
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
