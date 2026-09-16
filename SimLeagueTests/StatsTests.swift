//
//  StatsTests.swift
//  SimLeagueTests
//
//  Created by Ivan Pasquariello on 24/08/2026.
//

import Testing

@testable import SimLeague

struct StatsTests {
    let pointsAfterWin = 3
    let goalsScoredInWin = 3
    let goalsAgainstInWin = 1
    let pointsAfterDraw = 1
    let goalsScoredInDraw = 2
    let goalsAgainstInDraw = 2
    let goalsScoredInDefeat = 4
    let goalsAgainstInDefeat = 7

    /// Used to test home or away statsDetail when they should not get updated.
    let statsWithoutUpdates = StatsDetail()

    @Test func recordStatsHomeWinShouldUpdateTotalAndHomeStatsDetailWithWin() {
        var stats = Stats()

        stats.recordStats(
            playingHome: true,
            matchOutcome: .homeWin,
            goalsScored: 3,
            goalsAgainst: 1
        )

        let totalStatsAfterUpdate = stats.totalStats
        let homeStatsAfterUpdate = stats.homeStats
        let awayStatsAfterUpdate = stats.awayStats

        #expect(
            totalStatsAfterUpdate.games == 1,
            "Total games count should be one after a home win"
        )
        #expect(
            homeStatsAfterUpdate.games == 1,
            "Home games count should be one after a home win"
        )
        #expect(
            totalStatsAfterUpdate.points == pointsAfterWin,
            "Total Points should be \(pointsAfterWin) after a home win"
        )
        #expect(
            homeStatsAfterUpdate.points == pointsAfterWin,
            "Home points should be \(pointsAfterWin) after a home win"
        )
        #expect(
            totalStatsAfterUpdate.goalsScored == goalsScoredInWin,
            "Total goals scored should be \(goalsScoredInWin) after the home registered win"
        )
        #expect(
            homeStatsAfterUpdate.goalsScored == goalsScoredInWin,
            "Home goals scored should be \(goalsScoredInWin) after the home registered win"
        )
        #expect(
            totalStatsAfterUpdate.goalsAgainst == goalsAgainstInWin,
            "Total goals against should be \(goalsAgainstInWin) after the home registered win"
        )
        #expect(
            homeStatsAfterUpdate.goalsAgainst == goalsAgainstInWin,
            "Home goals against should be \(goalsAgainstInWin) after the home registered win"
        )
        #expect(
            totalStatsAfterUpdate.goalsDifference == goalsScoredInWin
                - goalsAgainstInWin,
            "Total goal difference should be \(goalsScoredInWin - goalsAgainstInWin) after the home win"
        )
        #expect(
            homeStatsAfterUpdate.goalsDifference == goalsScoredInWin
                - goalsAgainstInWin,
            "Home goal difference should be \(goalsScoredInWin - goalsAgainstInWin) after the home win"
        )
        #expect(
            totalStatsAfterUpdate.wins == 1,
            "Total wins count should be one after a home win"
        )
        #expect(
            homeStatsAfterUpdate.wins == 1,
            "Home wins count should be one after a home win"
        )
        #expect(
            totalStatsAfterUpdate.draws == 0,
            "Total draws count should be zero after a home win"
        )
        #expect(
            homeStatsAfterUpdate.draws == 0,
            "Home draws count should be zero after a home win"
        )
        #expect(
            totalStatsAfterUpdate.defeats == 0,
            "Total defeats count should be zero after a home win"
        )
        #expect(
            homeStatsAfterUpdate.defeats == 0,
            "Home defeats count should be zero after a home win"
        )
        #expect(
            awayStatsAfterUpdate == statsWithoutUpdates,
            "Away stats details should not be updated after a home game."
        )
    }

    @Test func recordStatsHomeDrawShouldUpdateTotalAndHomeStatsDetailWithDraw()
    {
        var stats = Stats()

        stats.recordStats(
            playingHome: true,
            matchOutcome: .draw,
            goalsScored: goalsScoredInDraw,
            goalsAgainst: goalsAgainstInDraw
        )

        let totalStatsAfterUpdate = stats.totalStats
        let homeStatsAfterUpdate = stats.homeStats
        let awayStatsAfterUpdate = stats.awayStats

        #expect(
            totalStatsAfterUpdate.points == pointsAfterDraw,
            "Total points should be \(pointsAfterDraw) after one home draw"
        )
        #expect(
            homeStatsAfterUpdate.points == pointsAfterDraw,
            "Home points should be \(pointsAfterDraw) after one home draw"
        )
        #expect(
            totalStatsAfterUpdate.points == pointsAfterDraw,
            "Total points should be \(pointsAfterDraw) after one home draw"
        )
        #expect(
            homeStatsAfterUpdate.points == pointsAfterDraw,
            "Home points should be \(pointsAfterDraw) after one home draw"
        )
        #expect(
            totalStatsAfterUpdate.goalsScored == goalsScoredInDraw,
            "Total goals scored should be \(goalsScoredInDraw) after a home draw"
        )
        #expect(
            homeStatsAfterUpdate.goalsScored == goalsScoredInDraw,
            "Home goals scored should be \(goalsScoredInDraw) after a home draw"
        )
        #expect(
            totalStatsAfterUpdate.goalsAgainst == goalsAgainstInDraw,
            "Total goals against should be \(goalsAgainstInDraw) after a home draw"
        )
        #expect(
            homeStatsAfterUpdate.goalsAgainst == goalsAgainstInDraw,
            "Home goals against should be \(goalsAgainstInDraw) after a home draw"
        )
        #expect(
            totalStatsAfterUpdate.goalsDifference == 0,
            "Goals difference should be zero for total stats after a home draw"
        )
        #expect(
            homeStatsAfterUpdate.goalsDifference == 0,
            "Goals difference should be zero for home stats after a home draw"
        )
        #expect(
            totalStatsAfterUpdate.games == 1,
            "Total games count should be one after a home draw"
        )
        #expect(
            homeStatsAfterUpdate.games == 1,
            "Home games count should be one after a home draw"
        )
        #expect(
            totalStatsAfterUpdate.wins == 0,
            "Total wins count should be zero after a home draw"
        )
        #expect(
            homeStatsAfterUpdate.wins == 0,
            "Home wins count should be zero after a home draw"
        )
        #expect(
            awayStatsAfterUpdate == statsWithoutUpdates,
            "Away stats detail should not be updated after a home draw"
        )
    }

    @Test
    func recordStatsHomeLossShouldUpdateTotalAndHomeStatsDetailWithDefeat() {
        var stats = Stats()

        stats.recordStats(
            playingHome: true,
            matchOutcome: .awayWin,
            goalsScored: goalsScoredInDefeat,
            goalsAgainst: goalsAgainstInDefeat
        )

        let totalStatsAfterUpdate = stats.totalStats
        let homeStatsAfterUpdate = stats.homeStats
        let awayStatsAfterUpdate = stats.awayStats

        #expect(
            totalStatsAfterUpdate.games == 1,
            "Total games count should be one after the first loss"
        )
        #expect(
            homeStatsAfterUpdate.games == 1,
            "Home games count should be one after the first loss"
        )
        #expect(
            totalStatsAfterUpdate.wins == 0,
            "Total wins count should be zero after a lost home game"
        )
        #expect(
            homeStatsAfterUpdate.wins == 0,
            "Home wins count should be zero after a lost home game"
        )
        #expect(
            totalStatsAfterUpdate.draws == 0,
            "Total draws should be zero after the lost home game"
        )
        #expect(
            homeStatsAfterUpdate.draws == 0,
            "Home draws should be zero after the lost home game"
        )
        #expect(
            totalStatsAfterUpdate.defeats == 1,
            "Total defeats count should be one after the defeat home game"
        )
        #expect(
            homeStatsAfterUpdate.defeats == 1,
            "Home defeats count should be one after the defeat home game"
        )
        #expect(
            totalStatsAfterUpdate.points == 0,
            "Total points should be zero after the home defeat"
        )
        #expect(
            homeStatsAfterUpdate.points == 0,
            "Home points should be zero after the home defeat"
        )
        #expect(
            totalStatsAfterUpdate.goalsScored == goalsScoredInDefeat,
            "Total goals scored should be \(goalsScoredInDefeat) after the home defeat"
        )
        #expect(
            homeStatsAfterUpdate.goalsScored == goalsScoredInDefeat,
            "Home goals scored should be \(goalsScoredInDefeat) after the home defeat"
        )
        #expect(
            totalStatsAfterUpdate.goalsAgainst == goalsAgainstInDefeat,
            "Total goals against should be \(goalsAgainstInDefeat) after the home defeat"
        )
        #expect(
            homeStatsAfterUpdate.goalsAgainst == goalsAgainstInDefeat,
            "Home goals against should be \(goalsAgainstInDefeat) after the home defeat"
        )
        #expect(
            totalStatsAfterUpdate.goalsDifference == goalsScoredInDefeat
                - goalsAgainstInDefeat,
            "Total goal difference should be \(goalsScoredInDefeat - goalsAgainstInDefeat) after the home defeat"
        )
        #expect(
            homeStatsAfterUpdate.goalsDifference == goalsScoredInDefeat
                - goalsAgainstInDefeat,
            "Home goal difference should be \(goalsScoredInDefeat - goalsAgainstInDefeat) after the home defeat"
        )
        #expect(
            awayStatsAfterUpdate == statsWithoutUpdates,
            "Away stats should not be updated after the home defeat"
        )
    }

    @Test func recordStatsAwayWinShouldUpdateTotalAndAwayStatsDetailWithWin() {
        var stats = Stats()

        stats.recordStats(
            playingHome: false,
            matchOutcome: .awayWin,
            goalsScored: goalsScoredInWin,
            goalsAgainst: goalsAgainstInWin
        )

        let totalStatsAfterUpdate = stats.totalStats
        let homeStatsAfterUpdate = stats.homeStats
        let awayStatsAfterUpdate = stats.awayStats

        #expect(
            totalStatsAfterUpdate.games == 1,
            "Total games should be one after the away win"
        )
        #expect(
            awayStatsAfterUpdate.games == 1,
            "Away games should be one after the away win"
        )
        #expect(
            totalStatsAfterUpdate.wins == 1,
            "Total games should be one after the away win"
        )
        #expect(
            awayStatsAfterUpdate.wins == 1,
            "Away games should be one after the away win"
        )
        #expect(
            totalStatsAfterUpdate.draws == 0,
            "Total draws should be zero after the away win"
        )
        #expect(
            awayStatsAfterUpdate.draws == 0,
            "Away draws should be zero after the away win"
        )
        #expect(
            totalStatsAfterUpdate.defeats == 0,
            "Total defeats should be zero after away win"
        )
        #expect(
            awayStatsAfterUpdate.defeats == 0,
            "Away defeats should be zero after away win"
        )
        #expect(
            totalStatsAfterUpdate.points == pointsAfterWin,
            "Total points should be \(pointsAfterWin) after away win."
        )
        #expect(
            awayStatsAfterUpdate.points == pointsAfterWin,
            "Away points should be \(pointsAfterWin) after away win."
        )
        #expect(
            totalStatsAfterUpdate.goalsScored == goalsScoredInWin,
            "Total goals scored should be \(goalsScoredInWin) after away win"
        )
        #expect(
            awayStatsAfterUpdate.goalsScored == goalsScoredInWin,
            "Away goals scored should be \(goalsScoredInWin) after away win"
        )
        #expect(
            totalStatsAfterUpdate.goalsDifference == goalsScoredInWin
                - goalsAgainstInWin,
            "Total goals difference should be \(goalsScoredInWin - goalsAgainstInWin) after away win"
        )
        #expect(
            awayStatsAfterUpdate.goalsDifference == goalsScoredInWin
                - goalsAgainstInWin,
            "Away goals difference should be \(goalsScoredInWin - goalsAgainstInWin) after away win"
        )
        #expect(
            homeStatsAfterUpdate == statsWithoutUpdates,
            "Home stats should not update after away win"
        )
    }

    @Test func recordStatsAwayDrawShouldUpdateTotalAndAwayStatsDetailWithDraw()
    {
        var stats = Stats()

        stats.recordStats(
            playingHome: false,
            matchOutcome: .draw,
            goalsScored: goalsScoredInDraw,
            goalsAgainst: goalsAgainstInDraw
        )

        let totalStatsAfterUpdate = stats.totalStats
        let homeStatsAfterUpdate = stats.homeStats
        let awayStatsAfterUpdate = stats.awayStats

        #expect(
            totalStatsAfterUpdate.games == 1,
            "Total games should be one after the away draw"
        )
        #expect(
            awayStatsAfterUpdate.games == 1,
            "Away games should be one after the away draw"
        )
        #expect(
            totalStatsAfterUpdate.points == pointsAfterDraw,
            "Total points should be \(pointsAfterDraw) after away draw"
        )
        #expect(
            awayStatsAfterUpdate.points == pointsAfterDraw,
            "Away points should be \(pointsAfterDraw) after away draw"
        )
        #expect(
            totalStatsAfterUpdate.wins == 0,
            "Total wins should be zero after the away draw"
        )
        #expect(
            awayStatsAfterUpdate.wins == 0,
            "Away wins should be zero after the away draw"
        )
        #expect(
            totalStatsAfterUpdate.draws == 1,
            "Total draws should be one after the away draw"
        )
        #expect(
            awayStatsAfterUpdate.draws == 1,
            "Away draws should be one after the away draw"
        )
        #expect(
            totalStatsAfterUpdate.defeats == 0,
            "Total defeats should be zero after the away draw"
        )
        #expect(
            awayStatsAfterUpdate.defeats == 0,
            "Away defeats should be zero after the away draw"
        )
        #expect(
            totalStatsAfterUpdate.goalsScored == goalsScoredInDraw,
            "Total goals scored should be \(goalsScoredInDraw) after the away draw"
        )
        #expect(
            awayStatsAfterUpdate.goalsScored == goalsScoredInDraw,
            "Away goals scored should be \(goalsScoredInDraw) after the away draw"
        )
        #expect(
            totalStatsAfterUpdate.goalsAgainst == goalsAgainstInDraw,
            "Total goals against should be \(goalsAgainstInDraw) after the away draw"
        )
        #expect(
            awayStatsAfterUpdate.goalsAgainst == goalsAgainstInDraw,
            "Away goals against should be \(goalsAgainstInDraw) after the away draw"
        )
        #expect(
            totalStatsAfterUpdate.goalsDifference == 0,
            "Total goal difference should be zero after the away draw"
        )
        #expect(
            awayStatsAfterUpdate.goalsDifference == 0,
            "Away goal difference should be zero after the away draw"
        )
        #expect(
            homeStatsAfterUpdate == statsWithoutUpdates,
            "Home stats should not be updated after the away draw"
        )
    }

    @Test
    func recordStatsAwayLossShouldUpdateTotalAndAwayStatsDetailWithDefeat() {
        var stats = Stats()

        stats.recordStats(
            playingHome: false,
            matchOutcome: .homeWin,
            goalsScored: goalsScoredInDefeat,
            goalsAgainst: goalsAgainstInDefeat
        )

        let totalStatsAfterUpdate = stats.totalStats
        let homeStatsAfterUpdate = stats.homeStats
        let awayStatsAfterUpdate = stats.awayStats

        #expect(
            totalStatsAfterUpdate.games == 1,
            "Total games should be 1 after the home loss"
        )
        #expect(
            awayStatsAfterUpdate.games == 1,
            "Away games should be 1 after the home loss"
        )
        #expect(
            totalStatsAfterUpdate.points == 0,
            "Total points should be zero after the away loss"
        )
        #expect(
            awayStatsAfterUpdate.points == 0,
            "Away points should be zero after the away loss"
        )
        #expect(
            totalStatsAfterUpdate.wins == 0,
            "Total wins should be zero after the away loss"
        )
        #expect(
            awayStatsAfterUpdate.wins == 0,
            "Away wins should be zero after the away loss"
        )
        #expect(
            totalStatsAfterUpdate.draws == 0,
            "Total draws should be zero after the away loss"
        )
        #expect(
            awayStatsAfterUpdate.draws == 0,
            "Away draws should be zero after the away loss"
        )
        #expect(
            totalStatsAfterUpdate.defeats == 1,
            "Total defeats should be one after the away loss"
        )
        #expect(
            awayStatsAfterUpdate.defeats == 1,
            "Away defeats should be one after the away loss"
        )
        #expect(
            totalStatsAfterUpdate.goalsScored == goalsScoredInDefeat,
            "Total goals scored should be \(goalsScoredInDefeat) after the away loss"
        )
        #expect(
            awayStatsAfterUpdate.goalsScored == goalsScoredInDefeat,
            "Away goals scored should be \(goalsScoredInDefeat) after the away loss"
        )
        #expect(
            totalStatsAfterUpdate.goalsAgainst == goalsAgainstInDefeat,
            "Total goals against should be \(goalsAgainstInDefeat) after the away loss"
        )
        #expect(
            awayStatsAfterUpdate.goalsAgainst == goalsAgainstInDefeat,
            "Away goals against should be \(goalsAgainstInDefeat) after the away loss"
        )
        #expect(
            totalStatsAfterUpdate.goalsDifference == goalsScoredInDefeat
                - goalsAgainstInDefeat,
            "Total goal difference should be \(goalsScoredInDefeat - goalsAgainstInDefeat) after the away loss"
        )
        #expect(
            awayStatsAfterUpdate.goalsDifference == goalsScoredInDefeat
                - goalsAgainstInDefeat,
            "Away goal difference should be \(goalsScoredInDefeat - goalsAgainstInDefeat) after the away loss"
        )
        #expect(
            homeStatsAfterUpdate == statsWithoutUpdates,
            "Home stats should not be updated after the away loss"
        )
    }

}
