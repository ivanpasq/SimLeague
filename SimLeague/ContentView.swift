//
//  ContentView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 22/08/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var league = League()
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var showDetails = false

    var body: some View {
        VStack {
            Button("Simulate") {
                league.simulateLeague()
            }

            Toggle(isOn: $showDetails) {
                Text("Show Details")
            }

            ScrollView {
                Grid {
                    TableHeaderView(
                        showDetails: showDetails
                    )

                    ForEach(league.table.standings(), id: \.team.id) { row in
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
        .padding()
    }
}

#Preview {
    ContentView()
}
