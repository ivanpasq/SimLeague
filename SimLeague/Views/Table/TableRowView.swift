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
    var showDetails: Bool

    var body: some View {
        GridRow {
            Text(String(position))
            Text(team.name)
                .gridColumnAlignment(.leading)
                .bold()
            Spacer()
            Text(String(stats.totalStats.games))
                .font(.subheadline)
            if showDetails {
                Text(String(stats.totalStats.wins))
                    .font(.caption)
                Text(String(stats.totalStats.draws))
                    .font(.caption)
                Text(String(stats.totalStats.defeats))
                    .font(.caption)
                Text(
                    "\(stats.totalStats.goalsScored) - \(stats.totalStats.goalsAgainst)"
                )
                .font(.caption)
            }
            Text(String(stats.totalStats.goalsDifference))
                .font(.subheadline)
            Text(String(stats.totalStats.points))
                .bold()
        }

        Divider()

    }
}

#Preview {
    let team = Team(
        name: "Juventus",
        attack: 80,
        defense: 80
    )
    TableRowView(
        team: team,
        stats: Stats(),
        position: 1,
        showDetails: true
    )
}
