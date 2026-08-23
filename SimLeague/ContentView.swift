//
//  ContentView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 22/08/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var league = League()
    
    var body: some View {
        VStack {
            Button("Simulate") {
                league.simulateLeague()
            }
            
            TableHeaderView()
            
            List(
                league.standings(),
                id: \.team.id
            ) { row in
                TableRowView(
                    team: row.team,
                    stats: row.stats,
                    position: row.position
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
