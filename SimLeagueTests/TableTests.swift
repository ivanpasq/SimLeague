//
//  TableTests.swift
//  SimLeagueTests
//
//  Created by Ivan Pasquariello on 26/08/2026.
//

import Testing

@testable import SimLeague

struct TableTests {

    @Test func checkStandingsRespectOrderingCriteria() throws {
        /**
         Order to check: points, goal difference, goals scored, alphabetical.
         So we need a Team with more point
         Then two teams with same point and different goals difference
         Then two teams with same point and same goals difference and different goals scored
         Then two teams with same point, same goals difference, same goals scored and different names.
         */

        let teamA = Team(name: "TeamA", attack: 99, defense: 99)
        let teamB = Team(name: "TeamB", attack: 99, defense: 99)
        let teamC = Team(name: "TeamC", attack: 99, defense: 99)
        let teamD = Team(name: "TeamD", attack: 99, defense: 99)
        let teamE = Team(name: "TeamE", attack: 99, defense: 99)
        let teamF = Team(name: "TeamF", attack: 99, defense: 99)
        let teamG = Team(name: "TeamG", attack: 99, defense: 99)

        var table = Table(with: [
            teamA,
            teamB,
            teamC,
            teamD,
            teamE,
            teamF,
            teamG,
        ])

        /**
         So we need a Team with more point
         */
        table.tableRows[teamA]?.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 10,
            goalsAgainst: 0
        )
        table.tableRows[teamA]?.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 10,
            goalsAgainst: 0
        )

        /**
         Then two teams with same point and different goals difference
         */
        table.tableRows[teamB]?.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 8,
            goalsAgainst: 0
        )
        table.tableRows[teamC]?.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 9,
            goalsAgainst: 0
        )

        /**
         Then two teams with same point and same goals difference and different goals scored
         */
        table.tableRows[teamD]?.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 7,
            goalsAgainst: 0
        )
        table.tableRows[teamE]?.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 8,
            goalsAgainst: 1
        )

        /**
         Then two teams with same point, same goals difference, same goals scored and different names.
         */
        table.tableRows[teamF]?.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 5,
            goalsAgainst: 0
        )
        table.tableRows[teamG]?.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 5,
            goalsAgainst: 0
        )

        let got = table.standings()
        let expected: [StandingRow] = [
            StandingRow(
                position: 1,
                team: teamA,
                stats: try #require(table.tableRows[teamA])
            ),
            StandingRow(
                position: 2,
                team: teamC,
                stats: try #require(table.tableRows[teamC])
            ),
            StandingRow(
                position: 3,
                team: teamB,
                stats: try #require(table.tableRows[teamB])
            ),
            StandingRow(
                position: 4,
                team: teamE,
                stats: try #require(table.tableRows[teamE])
            ),
            StandingRow(
                position: 5,
                team: teamD,
                stats: try #require(table.tableRows[teamD])
            ),
            StandingRow(
                position: 6,
                team: teamF,
                stats: try #require(table.tableRows[teamF])
            ),
            StandingRow(
                position: 7,
                team: teamG,
                stats: try #require(table.tableRows[teamG])
            ),
        ]

        #expect(
            got == expected,
            "Table standing should adhere to ordering rules"
        )

    }

}
