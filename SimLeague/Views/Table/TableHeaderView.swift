//
//  TableHeaderView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 23/08/2026.
//

import SwiftUI

struct TableHeaderView: View {
    var showDetails: Bool

    var body: some View {
        GridRow {

            Text("POS")
            Text("TEAM")
                .gridColumnAlignment(.leading)
            Spacer()
            Text("P")
                .font(.subheadline)
            if showDetails {
                Text("W")
                    .font(.caption)
                Text("D")
                    .font(.caption)
                Text("L")
                    .font(.caption)
                Text("GS-GA")
                    .font(.caption)
            }
            Text("GD")
                .font(.subheadline)
            Text("PTS")
        }
        .fontWeight(.light)
        
        Divider()
    }
}

#Preview {
    TableHeaderView(showDetails: true)
}
