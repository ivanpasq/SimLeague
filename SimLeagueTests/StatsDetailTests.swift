//
//  StatsDetailTests.swift
//  SimLeagueTests
//
//  Created by Ivan Pasquariello on 23/08/2026.
//

import Testing

@testable import SimLeague

struct StatsDetailTests {
    let pointsAfterWin = 3
    let goalsScoredInWin = 3
    let goalsAgainstInWin = 1
    let pointsAfterDraw = 1
    let goalsScoredInDraw = 2
    let goalsAgainstInDraw = 2
    let goalsScoredInLoss = 2
    let goalsAgainstInLoss = 4

    @Test func recordWinInStatsDetailShouldUpdateAccordingly() {
        var statsDetail = StatsDetail()

        statsDetail
            .record(
                statToRegister: .win,
                withGoalsScored: goalsScoredInWin,
                withGoalsAgainst: goalsAgainstInWin
            )

        #expect(
            statsDetail.points == pointsAfterWin,
            "Points after win should be \(pointsAfterWin)"
        )
        #expect(
            statsDetail.games == 1,
            "Games count should be one after one game"
        )
        #expect(
            statsDetail.goalsScored == goalsScoredInWin,
            "Goals scored should be \(goalsScoredInWin)"
        )
        #expect(
            statsDetail.goalsAgainst == goalsAgainstInWin,
            "Goals against should be \(goalsAgainstInWin)"
        )
        #expect(
            statsDetail.goalsDifference == goalsScoredInWin
                - goalsAgainstInWin,
            "Goal difference should be 2"
        )
        #expect(
            statsDetail.wins == 1,
            "Wins count should be one"
        )
        #expect(
            statsDetail.draws == 0,
            "Draws count should be zero after a win"
        )
        #expect(
            statsDetail.defeats == 0,
            "Defeats count should be zero after a win"
        )
    }

    @Test func recordDrawInStatsDetailShouldUpdateAccordingly() {
        var statsDetail = StatsDetail()

        statsDetail
            .record(
                statToRegister: .draw,
                withGoalsScored: goalsScoredInDraw,
                withGoalsAgainst: goalsAgainstInDraw
            )

        #expect(
            statsDetail.points == pointsAfterDraw,
            "Point after draw should be \(pointsAfterDraw)"
        )
        #expect(
            statsDetail.games == 1,
            "Games count shoyld be one after one game"
        )
        #expect(
            statsDetail.goalsScored == goalsScoredInDraw,
            "Goals scored should be \(goalsScoredInDraw)"
        )
        #expect(
            statsDetail.goalsAgainst == goalsAgainstInDraw,
            "Goals against should be \(goalsAgainstInDraw)"
        )
        #expect(
            statsDetail.goalsDifference == 0,
            "Goal difference after a draw should be zero"
        )
        #expect(
            statsDetail.games == 1,
            "Games count should be one after one game"
        )
        #expect(
            statsDetail.wins == 0,
            "Wins count should be zero after a draw"
        )
        #expect(
            statsDetail.defeats == 0,
            "Defeats count should be zero after a draw"
        )
        #expect(
            statsDetail.draws == 1,
            "Draws count should be one after one draw"
        )
    }

    @Test func recordLossInStatsDetailShouldUpdateAccordingly() {
        var statsDetail = StatsDetail()

        statsDetail
            .record(
                statToRegister: .loss,
                withGoalsScored: goalsScoredInLoss,
                withGoalsAgainst: goalsAgainstInLoss
            )

        #expect(
            statsDetail.points == 0,
            "Points should be zero after one loss"
        )
        #expect(
            statsDetail.wins == 0,
            "Wins should be zero after one loss"
        )
        #expect(
            statsDetail.draws == 0,
            "Draws should be zero after one loss"
        )
        #expect(
            statsDetail.goalsScored == goalsScoredInLoss,
            "Goals scored in loss should be \(goalsScoredInLoss)"
        )
        #expect(
            statsDetail.goalsAgainst == goalsAgainstInLoss,
            "Goals scored in loss should be \(goalsAgainstInLoss)"
        )
        #expect(
            statsDetail.goalsDifference == goalsScoredInLoss
                - goalsAgainstInLoss,
            "Goals difference in loss should be \(goalsScoredInLoss - goalsAgainstInLoss)"
        )
        #expect(
            statsDetail.games == 1,
            "Games count should be one after one game"
        )
        #expect(
            statsDetail.defeats == 1,
            "Defeats count should be one after one loss"
        )
    }

}
