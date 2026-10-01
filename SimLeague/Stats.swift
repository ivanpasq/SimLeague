//
//  Stats.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 24/08/2026.
//

import Foundation

struct Stats: Equatable {
    var totalStats: StatsDetail = StatsDetail()
    var homeStats: StatsDetail = StatsDetail()
    var awayStats: StatsDetail = StatsDetail()

    enum Outcome {
        case win
        case loss
        case draw
    }

    mutating func recordStats(
        playingHome: Bool,
        matchOutcome: MatchOutcome,
        goalsScored: Int,
        goalsAgainst: Int
    ) {
        let statToRegister: Outcome
        switch matchOutcome {
        case .homeWin:
            if playingHome {
                statToRegister = .win
            } else {
                statToRegister = .loss
            }
        case .awayWin:
            if playingHome {
                statToRegister = .loss
            } else {
                statToRegister = .win
            }
        case .draw:
            statToRegister = .draw
        }

        totalStats
            .record(
                statToRegister: statToRegister,
                withGoalsScored: goalsScored,
                withGoalsAgainst: goalsAgainst
            )

        if playingHome {
            homeStats
                .record(
                    statToRegister: statToRegister,
                    withGoalsScored: goalsScored,
                    withGoalsAgainst: goalsAgainst
                )
        } else {
            awayStats
                .record(
                    statToRegister: statToRegister,
                    withGoalsScored: goalsScored,
                    withGoalsAgainst: goalsAgainst
                )
        }
    }
}

struct StatsDetail: Equatable {
    var points: Int = 0
    var games: Int = 0
    var wins: Int = 0
    var draws: Int = 0
    var defeats: Int = 0
    var goalsScored: Int = 0
    var goalsAgainst: Int = 0
    var goalsDifference: Int { goalsScored - goalsAgainst }

    mutating func record(
        statToRegister: Stats.Outcome,
        withGoalsScored goalsScored: Int,
        withGoalsAgainst goalsAgainst: Int
    ) {
        switch statToRegister {
        case .win:
            registerWin(
                withGoalsScored: goalsScored,
                withGoalsAgainst: goalsAgainst
            )
        case .loss:
            registerLose(
                withGoalsScored: goalsScored,
                withGoalsAgainst: goalsAgainst
            )
        case .draw:
            registerDraw(withGoals: goalsScored)
        }
    }

    mutating private func registerWin(
        withGoalsScored goalsScored: Int,
        withGoalsAgainst goalsAgainst: Int
    ) {
        points += 3
        games += 1
        wins += 1
        self.goalsScored += goalsScored
        self.goalsAgainst += goalsAgainst
    }

    mutating private func registerDraw(withGoals goalsNumber: Int) {
        points += 1
        games += 1
        draws += 1
        goalsScored += goalsNumber
        goalsAgainst += goalsNumber
    }

    mutating private func registerLose(
        withGoalsScored goalsScored: Int,
        withGoalsAgainst goalsAgainst: Int
    ) {
        games += 1
        defeats += 1
        self.goalsScored += goalsScored
        self.goalsAgainst += goalsAgainst
    }
}
