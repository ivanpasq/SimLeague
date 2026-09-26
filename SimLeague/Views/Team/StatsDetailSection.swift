//
//  StatsDetailSection.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 26/09/2026.
//

import SwiftUI

struct StatsDetailSection: View {
    let statsDetails: StatsDetail

    var body: some View {
        LabeledContent("Points", value: String(statsDetails.points))
        LabeledContent("Games Played", value: String(statsDetails.games))
        LabeledContent("Wins", value: String(statsDetails.wins))
        LabeledContent("Draws", value: String(statsDetails.draws))
        LabeledContent("Defeats", value: String(statsDetails.defeats))
        LabeledContent(
            "Goals Scored",
            value: String(statsDetails.goalsScored)
        )
        LabeledContent(
            "Goals Against",
            value: String(statsDetails.goalsAgainst)
        )
        LabeledContent(
            "Goal Difference",
            value: String(statsDetails.goalsDifference)
        )
    }
}

#Preview {
    let previewStatsDetails = StatsDetail()

    List {
        Section(header: Text("Stats Preview")) {
            StatsDetailSection(
                statsDetails: previewStatsDetails
            )
        }
    }
}
