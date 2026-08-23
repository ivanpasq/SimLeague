//
//  Team.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 10/08/2026.
//

import Foundation

struct Team: Hashable, Identifiable {
    let id: UUID
    let name: String
    let attack: Double
    let defense: Double

    init(id: UUID = UUID(), name: String, attack: Double, defense: Double) {
        self.id = id
        self.name = name
        self.attack = attack
        self.defense = defense
    }

    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func withStrength(offensive: Double, defensive: Double) -> Team {
        Team(
            id: id,
            name: name,
            attack: offensive,
            defense: defensive
        )
    }
}
