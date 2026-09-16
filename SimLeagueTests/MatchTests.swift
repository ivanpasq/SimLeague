//
//  MatchTests.swift
//  SimLeagueTests
//
//  Created by Ivan Pasquariello on 25/08/2026.
//

import Testing

@testable import SimLeague

struct MatchTests {
    let homeTeam = Team(name: "Inter", attack: 99, defense: 99)
    let awayTeam = Team(name: "Juventus", attack: 80, defense: 80)

    let homeAdvantage = 1.20
    let averageGoalsAmount = 1.10

    let numberOfSimulation = 1_000

    @Test func checkAvarageAndVarianceInSimulatedMatch() {
        let homeTeamExpectedGoals = expectedGoals(
            attack: homeTeam.attack,
            defense: awayTeam.defense,
            averageGoals: averageGoalsAmount,
            withHomeAdvantage: homeAdvantage
        )
        let awayTeamExpectedGoals = expectedGoals(
            attack: awayTeam.attack,
            defense: homeTeam.defense,
            averageGoals: averageGoalsAmount
        )

        var totalHomeGoals = 0
        var totalAwayGoals = 0
        var totalHomeWins = 0
        var totalAwayWins = 0
        var totalDraws = 0

        var homeGoalsArray: [Int] = []
        var awayGoalsArray: [Int] = []

        for _ in 0..<numberOfSimulation {
            let homeGoals = calculateGoals(lambda: homeTeamExpectedGoals)
            let awayGoals = calculateGoals(lambda: awayTeamExpectedGoals)

            homeGoalsArray.append(homeGoals)
            awayGoalsArray.append(awayGoals)

            totalHomeGoals += homeGoals
            totalAwayGoals += awayGoals

            if homeGoals > awayGoals {
                totalHomeWins += 1
            } else if awayGoals > homeGoals {
                totalAwayWins += 1
            } else {
                totalDraws += 1
            }
        }

        let homeGoalsAverage =
            Double(totalHomeGoals) / Double(numberOfSimulation)
        let homeGoalPowSum = homeGoalsArray.reduce(
            0.0,
            { acc, goals in
                acc + (Double(goals) - homeGoalsAverage)
                    * (Double(goals) - homeGoalsAverage)
            }
        )
        let homeGoalsVariance = homeGoalPowSum / Double(numberOfSimulation)

        let awayGoalsAverage =
            Double(totalAwayGoals) / Double(numberOfSimulation)
        let awayGoalPowSum = awayGoalsArray.reduce(
            0.0,
            { acc, goals in
                acc + (Double(goals) - awayGoalsAverage)
                    * (Double(goals) - awayGoalsAverage)
            }
        )
        let awayGoalsVariance = awayGoalPowSum / Double(numberOfSimulation)

        #expect(
            abs(homeGoalsAverage - homeTeamExpectedGoals) < 0.2,
            "Average home goals should be very close to the home expected goals."
        )
        #expect(
            abs(awayGoalsAverage - awayTeamExpectedGoals) < 0.2,
            "Average away goals should be very close to the away expected goals."
        )
        #expect(
            abs(homeGoalsVariance - homeTeamExpectedGoals) < 0.2,
            "Home goals variance should be very close to the home expected goals."
        )
        #expect(
            abs(awayGoalsVariance - awayTeamExpectedGoals) < 0.2,
            "Away goals variance should be very close to the away expected goals."
        )
    }

}
