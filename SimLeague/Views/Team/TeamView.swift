//
//  TeamView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 25/09/2026.
//

import SwiftUI

enum TeamViewDetails {
    case stats
    case calendar
}

struct TeamView: View {
    let team: Team
    let league: League

    @State private var detailSelection: TeamViewDetails = .stats

    var body: some View {

        VStack {

            Picker("Team Details", selection: $detailSelection) {
                Text("Stats")
                    .tag(TeamViewDetails.stats)
                Text("Calendar")
                    .tag(TeamViewDetails.calendar)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            switch detailSelection {
            case .stats:
                List {
                    Section("Details") {

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
                        if let teamPosition = league.table.position(of: team) {
                            LabeledContent(
                                "Position",
                                value: String(teamPosition)
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
            case .calendar:
                List {
                    ForEach(
                        league.schedule.matches(for: team),
                        id: \.matchDayIndex
                    ) { matchDay in
                        Section(
                            "Match Day \(matchDay.matchDayIndex + 1)"
                        ) {
                            let homeTeamName = matchDay.match.homeTeam
                                .name
                            let awayTeamName = matchDay.match.awayTeam
                                .name
                            if let matchResult = matchDay.match
                                .matchResult
                            {
                                HStack {
                                    Text(homeTeamName)
                                    Text(String(matchResult.homeTeamGoals))
                                    Text("-")
                                    Text(String(matchResult.awayTeamGoals))
                                    Text(awayTeamName)
                                }
                            } else {
                                HStack {
                                    Text(homeTeamName)
                                    Text(" - ")
                                    Text(awayTeamName)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
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
