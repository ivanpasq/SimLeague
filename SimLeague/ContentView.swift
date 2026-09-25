//
//  ContentView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 22/08/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var league = League()
    @State private var showDetails = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()

                    Button("Sim League") {
                        league.simulateLeague()
                    }
                    .disabled(league.isSeasonOver)
                    .buttonStyle(.glassProminent)

                    NavigationLink(
                        "MatchDay",
                        destination: MatchDayView(
                            league: league,
                            selectedMatchDay: league.isSeasonOver
                                ? league.nextMatchDayIndex - 1
                                : league.nextMatchDayIndex
                        )
                    )
                    .buttonStyle(.glassProminent)

                    Button("Reset") {
                        league.reset()
                    }
                    .disabled(league.nextMatchDayIndex == 0)
                    .buttonStyle(.glass)
                    .tint(.red)
                }
                .padding()

                Toggle(isOn: $showDetails) {
                    Text("Show Details")
                }
                .padding(.horizontal)

                ScrollView {
                    Grid {
                        TableHeaderView(
                            showDetails: showDetails
                        )

                        ForEach(league.table.standings(), id: \.team.id) {
                            row in
                            TableRowView(
                                team: row.team,
                                stats: row.stats,
                                position: row.position,
                                showDetails: showDetails
                            )
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
