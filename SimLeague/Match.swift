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

func checkGeneratedSchedule(of schedule: [[Match]], for teams: [Team]) -> Bool {
    let numberOfSingleLegTotalGames = (teams.count - 1)
    let numberOfLegsToCheck = numberOfSingleLegTotalGames * 2
    var checkResult = true
    if numberOfLegsToCheck != schedule.count {
        print(
            "Number of legs is not ok: expected \(numberOfLegsToCheck), found \(schedule.count)"
        )
        checkResult = false
    }

    let numberOfGamesPerLegToCheck = (teams.count / 2)
    let totalNumberOfGamesToCheck =
        numberOfLegsToCheck * numberOfGamesPerLegToCheck
    var totalMatches = 0
    var teamHomeGameCount = [Team: Int]()
    var teamAwayGameCount = [Team: Int]()

    for (i, leg) in schedule.enumerated() {
        if leg.count != numberOfGamesPerLegToCheck {
            print(
                "Number of games for leg \(i + 1) is not ok, expected \(numberOfGamesPerLegToCheck), found \(leg.count)"
            )
            checkResult = false
        }

        totalMatches += leg.count

        var legTeamSet = Set<Team>()
        for game in leg {
            var (ok, foundTeam) = legTeamSet.insert(game.homeTeam)
            if !ok {
                print("Team \(foundTeam.name) duplicate in leg \(i + 1)")
                checkResult = false
            }
            teamHomeGameCount[game.homeTeam, default: 0] += 1
            (ok, foundTeam) = legTeamSet.insert(game.awayTeam)
            if !ok {
                print("Team \(foundTeam.name) duplicate in leg \(i + 1)")
                checkResult = false
            }
            teamAwayGameCount[game.awayTeam, default: 0] += 1
        }

        if legTeamSet.count != teams.count {
            for team in teams {
                if !legTeamSet.contains(team) {
                    print("Missing \(team.name) from Leg \(i + 1)")
                    checkResult = false
                }
            }
        }
    }

    if totalNumberOfGamesToCheck != totalMatches {
        print(
            "Number of total games is not ok, expected \(totalNumberOfGamesToCheck), found \(totalMatches)"
        )
        checkResult = false
    }

    for team in teams {
        if teamHomeGameCount[team] != numberOfSingleLegTotalGames
            || teamAwayGameCount[team] != numberOfSingleLegTotalGames
        {
            print(
                "Number of Home / Away match for Team \(team.name) is not ok, expected \(numberOfSingleLegTotalGames), found for Home \(teamHomeGameCount[team, default: 0]) and for Away \(teamAwayGameCount[team, default: 0])"
            )
            checkResult = false
        }
    }

    return checkResult
}

func checkSimulation(
    match: Match,
    withHomeAdvantage homeAdv: Double,
    averageGoalsAmount: Double
) {
    print(" --- Check Match Simulation --- ")
    print("Check for match: \(match.homeTeam.name) - \(match.awayTeam.name)...")

    let homeExpGoals = expectedGoals(
        attack: match.homeTeam.attack,
        defense: match.awayTeam.defense,
        averageGoals: averageGoalsAmount,
        withHomeAdvantage: homeAdv
    )
    let awayExpGoals = expectedGoals(
        attack: match.awayTeam.attack,
        defense: match.homeTeam.defense,
        averageGoals: averageGoalsAmount
    )

    print(homeExpGoals)
    print(awayExpGoals)

    let numberOfSimulations = 10000

    var totalHomeGoals = 0
    var totalAwayGoals = 0
    var totalHomeWins = 0
    var totalAwayWins = 0
    var totalDraws = 0

    var homeGoalsArray: [Int] = []
    var awayGoalsArray: [Int] = []

    for _ in 0..<numberOfSimulations {
        let homeGoals = calculateGoals(lambda: homeExpGoals)
        let awayGoals = calculateGoals(lambda: awayExpGoals)

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

    print("Total Home Goals: \(totalHomeGoals)")
    print("Total Away Goals: \(totalAwayGoals)")

    print("Total Home Wins: \(totalHomeWins)")
    print("Total Away Wins: \(totalAwayWins)")
    print("Total Draws: \(totalDraws)")

    print(
        "Home Wins Percentage: \(String(format: "%.2f", (Double(totalHomeWins) / Double(numberOfSimulations)) * 100.0))%"
    )
    print(
        "Away Wins Percentage: \(String(format: "%.2f", (Double(totalAwayWins) / Double(numberOfSimulations)) * 100.0))%"
    )
    print(
        "Draws Percentage: \(String(format: "%.2f", (Double(totalDraws) / Double(numberOfSimulations)) * 100.0))%"
    )

    let homeGoalsAverage = Double(totalHomeGoals) / Double(numberOfSimulations)
    let awayGoalsAverage = Double(totalAwayGoals) / Double(numberOfSimulations)

    let homeGoalPowSum = homeGoalsArray.reduce(
        0.0,
        { acc, goals in
            acc + (Double(goals) - homeGoalsAverage)
                * (Double(goals) - homeGoalsAverage)
        }
    )

    print("Home Goals Average: \(homeGoalsAverage)")
    print(
        "Home Goals Variance: \(homeGoalPowSum / Double(numberOfSimulations))"
    )

    let awayGoalPowSum = awayGoalsArray.reduce(
        0.0,
        { acc, goals in
            acc + (Double(goals) - awayGoalsAverage)
                * (Double(goals) - awayGoalsAverage)
        }
    )

    print("Away Goals Average: \(awayGoalsAverage)")
    print(
        "Away Goals Variance: \(awayGoalPowSum / Double(numberOfSimulations))"
    )

    print(" --- Check Match Simulation END --- ")
    print(" ")
}

private func expectedGoals(
    attack: Double,
    defense: Double,
    averageGoals: Double,
    withHomeAdvantage: Double = 1.0
) -> Double {
    Double(attack) / Double(defense) * averageGoals * withHomeAdvantage
}

private func calculateGoals(lambda: Double) -> Int {
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
