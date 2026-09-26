//
//  MatchDayView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 22/09/2026.
//

import SwiftUI

struct MatchDayView: View {
    let league: League
    @State var selectedMatchDay: Int

    var body: some View {
        VStack {
            Picker("Match Day", selection: $selectedMatchDay) {
                ForEach(league.schedule.indices, id: \.self) { i in
                    Text(String(i + 1))
                }
            }

            Grid(verticalSpacing: 10) {
                ForEach(
                    league.schedule[selectedMatchDay].enumerated(),
                    id: \.offset
                ) { match in
                    GridRow {
                        NavigationLink(value: match.element.homeTeam) {
                            Text(match.element.homeTeam.name)
                        }
                        .buttonStyle(.plain)
                        .bold()
                        .padding(.horizontal)

                        if let matchResult = match.element.matchResult {
                            HStack {
                                Text(String(matchResult.homeTeamGoals))
                                Text(" - ")
                                Text(String(matchResult.awayTeamGoals))
                            }
                        } else {
                            Text(" - ")
                        }

                        NavigationLink(value: match.element.awayTeam) {
                            Text(match.element.awayTeam.name)
                        }
                        .buttonStyle(.plain)
                        .bold()
                        .padding(.horizontal)
                    }
                }
            }

            Spacer()

            Button("Simulate") {
                league.simulateNextMatchDay()
            }
            .padding()
            .disabled(selectedMatchDay != league.nextMatchDayIndex)
            .buttonStyle(.glassProminent)
        }
        .navigationTitle("Match Day \(selectedMatchDay + 1)")
    }
}

struct MatchDayDestination: Hashable {
    let index: Int
}

#Preview {
    let previewLeague = League()

    NavigationStack {
        MatchDayView(
            league: previewLeague,
            selectedMatchDay: previewLeague.nextMatchDayIndex
        )
    }
}
