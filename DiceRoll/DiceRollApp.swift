//
//  DiceRollApp.swift
//  DiceRoll
//
//  Created by Daria Yatsyniuk on 30.07.2025.
//
import SwiftData
import SwiftUI

@main
struct DiceRollApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DiceRoll.self)
    }
}
