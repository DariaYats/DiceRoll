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

    var body: some View {
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
}

#Preview {
    RollsHistoryView()
}
