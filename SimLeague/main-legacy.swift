//
//  main.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 10/08/2026.
//

import Foundation

struct TeamResults: CustomStringConvertible {
    let team: Team
    var titleCount: Int = 0
    var firstQuarterCount: Int = 0
    var lastThreeCount: Int = 0
    var totalPoints: Int = 0
    var averagePoints: Double = 0
    var maxPointsInASeason: Int = 0
    var leastPointsInASeason: Int = Int.max

    let description: String

    init(team: Team, finalTableList: [[(team: Team, stats: Stats)]]) {
        self.team = team

        for season in finalTableList {
            for (i, teamStanding) in season.enumerated() {
                if teamStanding.team == team {
                    if i == 0 {
                        titleCount += 1
                    }
                    if i < season.count / 4 {
                        firstQuarterCount += 1
                    }
                    if i > season.count - 4 {
                        lastThreeCount += 1
                    }
                    totalPoints += teamStanding.stats.totalStats.points
                    if maxPointsInASeason < teamStanding.stats.totalStats.points
                    {
                        maxPointsInASeason =
                            teamStanding.stats.totalStats.points
                    }
                    if leastPointsInASeason
                        > teamStanding.stats.totalStats.points
                    {
                        leastPointsInASeason =
                            teamStanding.stats.totalStats.points
                    }

                    break
                }
            }
        }

        averagePoints = Double(totalPoints) / Double(finalTableList.count)

        description =
            "Team: \(team.name.padding(toLength: 10, withPad: " ", startingAt: 0)) | Title Count: \(titleCount) | First Four Count: \(firstQuarterCount) | Last Three Count: \(lastThreeCount) | Total Points: \(totalPoints) | Average Points per Season: \(averagePoints) | Max Points in a Season: \(maxPointsInASeason) | Least Points in a Season: \(leastPointsInASeason)"
    }
}

enum AverageStrengthBaseField {
    case attack
    case defense
}

func calculateAverageStrength(
    for teamList: [Team],
    using baseField: AverageStrengthBaseField
) -> Double {
    switch baseField {
    case .attack:
        return teamList.reduce(
            0.0,
            { sumAttack, team in
                sumAttack + team.attack
            }
        ) / Double(teamList.count)
    case .defense:
        return teamList.reduce(
            0.0,
            { sumDefense, team in
                sumDefense + team.defense
            }
        ) / Double(teamList.count)
    }
}

let teams = [
    Team(name: "Inter", attack: 99, defense: 83),
    Team(name: "Napoli", attack: 82, defense: 84),
    Team(name: "Roma", attack: 87, defense: 94),
    Team(name: "Como", attack: 85, defense: 87),
    Team(name: "Milan", attack: 82, defense: 85),
    Team(name: "Juventus", attack: 89, defense: 90),
    Team(name: "Atalanta", attack: 75, defense: 81),
    Team(name: "Bologna", attack: 73, defense: 67),
    Team(name: "Lazio", attack: 65, defense: 77),
    Team(name: "Udinese", attack: 69, defense: 66),
    Team(name: "Sassuolo", attack: 70, defense: 66),
    Team(name: "Torino", attack: 68, defense: 60),
    Team(name: "Parma", attack: 60, defense: 70),
    Team(name: "Cagliari", attack: 63, defense: 62),
    Team(name: "Fiorentina", attack: 72, defense: 72),
    Team(name: "Genoa", attack: 65, defense: 65),
    Team(name: "Lecce", attack: 55, defense: 66),
    Team(name: "Venezia", attack: 52, defense: 60),
    Team(name: "Frosinone", attack: 48, defense: 56),
    Team(name: "Monza", attack: 55, defense: 62),
]

let attackAverage = calculateAverageStrength(for: teams, using: .attack)

let defenseAverage = calculateAverageStrength(for: teams, using: .defense)

/// The factor used to spread team values to achieve more realistic results
let k = 1.8

var newTeamList: [Team] = []

for team in teams {
    newTeamList.append(
        team
            .withStrength(
                offensive: attackAverage + k * (team.attack - attackAverage),
                defensive: defenseAverage + k * (team.defense - defenseAverage)
            )
    )
}

let newAttackAverage = calculateAverageStrength(
    for: newTeamList,
    using: .attack
)

let newDefenseAverage = calculateAverageStrength(
    for: newTeamList,
    using: .defense
)

if abs(attackAverage - newAttackAverage) > 0.0001 {
    print(
        "Something is off with the new calculated attack value - Old value: \(attackAverage), New value: \(newAttackAverage)"
    )
}
if abs(defenseAverage - newDefenseAverage) > 0.001 {
    print(
        "Something is off with the new calculated defense value - Old value: \(defenseAverage), New value: \(newDefenseAverage)"
    )
}

var finalTableList: [[(team: Team, stats: Stats)]] = []

for _ in 0..<100 {
    var league = League(
        teams: newTeamList,
        table: Table(with: newTeamList)
    )

    league.simulateLeague()

    if checkSimulatedLeague(league: league) {
        finalTableList.append(league.standings())
    }
}

var seasonResultsList: [TeamResults] = []

for team in newTeamList {
    seasonResultsList.append(
        TeamResults(team: team, finalTableList: finalTableList)
    )
}

seasonResultsList.sort(by: { $0.averagePoints > $1.averagePoints })

for results in seasonResultsList {
    print(results)
}
