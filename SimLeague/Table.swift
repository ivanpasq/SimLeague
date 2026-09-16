//
//  Table.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 19/08/2026.
//

import Foundation

struct StandingRow: Equatable {
    let position: Int
    let team: Team
    let stats: Stats
}

struct Table {
    var tableRows: [Team: Stats]

    init(with teams: [Team]) {
        var rows: [Team: Stats] = [:]

        for team in teams {
            rows[team] = Stats()
        }

        tableRows = rows
    }
    
    func standings() -> [StandingRow] {
        tableRows
            .sorted(
                by: {
                    if $0.value.totalStats.points != $1.value.totalStats.points
                    {
                        return $0.value.totalStats.points
                        > $1.value.totalStats.points
                    } else if $0.value.totalStats.goalsDifference
                                != $1.value.totalStats.goalsDifference
                    {
                        return $0.value.totalStats.goalsDifference
                        > $1.value.totalStats.goalsDifference
                    } else if $0.value.totalStats.goalsScored
                                != $1.value.totalStats.goalsScored
                    {
                        return $0.value.totalStats.goalsScored
                        > $1.value.totalStats.goalsScored
                    } else {
                        return $0.key.name < $1.key.name
                    }
                }
            )
            .enumerated()
            .map {
                StandingRow(
                    position: $0.offset + 1,
                    team: $0.element.key,
                    stats: $0.element.value
                )
            }
    }
}
