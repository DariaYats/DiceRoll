//
//  RollsHistoryView.swift
//  DiceRoll
//
//  Created by Daria Yatsyniuk on 05.08.2025.
//
import SwiftData
import SwiftUI

struct RollsHistoryView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var rollHistory: [DiceRoll]

    @State private var isShowingAlert = false

    var body: some View {
        if rollHistory.isEmpty {
            Text("Roll your first dice and check the history below!")
        } else {
            List {
                Section(header: Text("Roll History")) {
                    ForEach(rollHistory.sorted(by: { $0.timestamp > $1.timestamp })) { roll in
                        VStack(alignment: .leading) {
                            Text("Total: \(roll.total)")
                            Text("Rolls: \(roll.individualRolls.map { String($0) }.joined(separator: ", "))")
                            Text("Dice: \(roll.diceAmount), Sides: \(roll.diceSides)")
                            Text("Time: \(roll.timestamp, formatter: dateFormatter)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteRoll)
                }
            }
            .toolbar {
                Button("Delete all history", systemImage:  "trash") {
                    isShowingAlert = true
                }
            }
            .alert("Are you sure you want to delete all roll history? This action cannot be undone.", isPresented: $isShowingAlert) {
                Button("Delete all") {
                    deleteAll()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }

    func deleteRoll(at offset: IndexSet) {
        for index in offset {
            modelContext.delete(rollHistory[index])
        }
    }

    func deleteAll() {
        do {
            let fetchDescriptor = FetchDescriptor<DiceRoll>()
            let allDiceRolls = try? modelContext.fetch(fetchDescriptor)
            for diceRoll in allDiceRolls ?? []  {
                modelContext.delete(diceRoll)
            }
            try modelContext.save()
        } catch {
            print("Failed to delete all objects: \(error)")
        }
    }
}

#Preview {
    RollsHistoryView()
}
