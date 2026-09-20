//
//  TableHeaderView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 23/08/2026.
//

import SwiftUI

struct TableHeaderView: View {
    var viewMode: TableViewMode
    
    var body: some View {
        GridRow {
            Text("Pos")
            Text("Name")
            if viewMode == .standard {
                Text("MP")
                Text("W")
                Text("D")
                Text("L")
                Text("GF")
                Text("GA")
                Text("GD")
            }
            Text("Pts")
        }
        .fontWeight(.light)
    }
}

#Preview {
    TableHeaderView(viewMode: .standard)
}
