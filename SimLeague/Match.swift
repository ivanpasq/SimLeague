//
//  Match.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 10/08/2026.
//

import Foundation

struct Match {
    let homeTeam: Team
    let awayTeam: Team
    var matchResult: MatchResult?

    @discardableResult
    mutating func simulate(
        withHomeAdvantage homeAdv: Double,
        averageGoalsAmount: Double
    ) -> MatchResult {
        let homeExpectedGoals = expectedGoals(
            attack: homeTeam.attack,
            defense: awayTeam.defense,
            averageGoals: averageGoalsAmount,
            withHomeAdvantage: homeAdv
        )
        let awayExpectedGoals = expectedGoals(
            attack: awayTeam.attack,
            defense: homeTeam.defense,
            averageGoals: averageGoalsAmount
        )

        let homeGoals = calculateGoals(lambda: homeExpectedGoals)
        let awayGoals = calculateGoals(lambda: awayExpectedGoals)

        let outcome: MatchOutcome
        if homeGoals > awayGoals {
            outcome = .homeWin
        } else if awayGoals > homeGoals {
            outcome = .awayWin
        } else {
            outcome = .draw
        }

        let matchResult = MatchResult(
            outcome: outcome,
            homeTeamGoals: homeGoals,
            awayTeamGoals: awayGoals
        )
        self.matchResult = matchResult
        return matchResult
    }
}

enum MatchOutcome {
    case homeWin
    case awayWin
    case draw
}

struct MatchResult {
    let outcome: MatchOutcome
    let homeTeamGoals: Int
    let awayTeamGoals: Int
}

func expectedGoals(
    attack: Double,
    defense: Double,
    averageGoals: Double,
    withHomeAdvantage: Double = 1.0
) -> Double {
    Double(attack) / Double(defense) * averageGoals * withHomeAdvantage
}

func calculateGoals(lambda: Double) -> Int {
    var counter = -1
    var tracker = 1.0
    let threshold = exp(-lambda)

    repeat {
        let rand = Double.random(in: 0..<1)
        tracker *= rand
        counter += 1
    } while tracker > threshold

    return counter
}
