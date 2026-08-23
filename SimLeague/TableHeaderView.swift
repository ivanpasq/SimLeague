//
//  TableHeaderView.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 23/08/2026.
//

import SwiftUI

struct TableHeaderView: View {
    var body: some View {
        HStack {
            Text("Name")
            Text("MP")
            Text("W")
            Text("D")
            Text("L")
            Text("GF")
            Text("GA")
            Text("GD")
            Text("Pts")
        }
        .bold()
    }
}

#Preview {
    TableHeaderView()
}
