//
//  TableRowView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 23/08/2026.
//

import SwiftUI

struct TableRowView: View {
    var team: Team
    var stats: Stats
    var position: Int
    
    var body: some View {
        HStack {
            Text("\(position).")
            Text(team.name)
                .bold()
            Text(String(stats.totalStats.games))
            Text(String(stats.totalStats.wins))
            Text(String(stats.totalStats.draws))
            Text(String(stats.totalStats.defeats))
            Text(String(stats.totalStats.goalsScored))
            Text(String(stats.totalStats.goalsAgainst))
            Text(String(stats.totalStats.goalsDifference))
            Text(String(stats.totalStats.points))
                .bold()
        }
    }
}

#Preview {
    let team = Team(
        name: "Juventus",
        attack: 80,
        defense: 80)
    TableRowView(
        team: team,
        stats: Stats(),
        position: 1
    )
}
