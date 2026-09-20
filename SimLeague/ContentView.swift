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

    private var currentTableViewMode: TableViewMode {
        var mode: TableViewMode = .standard
        if dynamicTypeSize >= .xxLarge {
            mode = .large
        }
        if dynamicTypeSize >= .accessibility2 {
            mode = .maxi
        }
        return mode
    }

    var body: some View {
        let tableViewMode = currentTableViewMode

        VStack {
            Button("Simulate") {
                league.simulateLeague()
            }

            ScrollView {
                Grid {
                    if tableViewMode != .maxi {
                        TableHeaderView(
                            viewMode: tableViewMode
                        )
                        
                        Divider()
                    }

                    ForEach(league.table.standings(), id: \.team.id) { row in
                        TableRowView(
                            team: row.team,
                            stats: row.stats,
                            position: row.position,
                            viewMode: tableViewMode
                        )
                        Divider()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
