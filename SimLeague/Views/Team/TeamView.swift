//
//  TeamView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 25/09/2026.
//

import SwiftUI

struct TeamView: View {
    let team: Team
    let league: League

    var body: some View {
        List {
            Section(header: Text("Details")) {

                LabeledContent(
                    "Attack",
                    value: team.attack.formatted(.number)
                )
                LabeledContent(
                    "Defense",
                    value: team.defense.formatted(.number)
                )
            }

            if let teamStats = league.table.tableRows[team] {
                if let teamStanding = league.table.standings().first(
                    where: { row in
                        row.team == team
                    })
                {
                    LabeledContent(
                        "Position",
                        value: String(teamStanding.position)
                    )
                    .bold()
                }

                Section("Total Stats") {
                    StatsDetailSection(
                        statsDetails: teamStats.totalStats
                    )
                }
                Section("Home Stats") {
                    StatsDetailSection(
                        statsDetails: teamStats.homeStats
                    )
                }
                Section("Away Stats") {
                    StatsDetailSection(
                        statsDetails: teamStats.awayStats
                    )
                }
            }
        }
        .navigationTitle(team.name)
    }
}

#Preview {
    let previewLeague = League()
    let previewTeam =
        previewLeague.teams.first
        ?? Team(
            name: "Juventus",
            attack: 80,
            defense: 80
        )

    NavigationStack {
        TeamView(team: previewTeam, league: previewLeague)
    }
}
