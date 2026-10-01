//
//  League.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 19/08/2026.
//

import Foundation

@MainActor
@Observable
class League {
    let teams: [Team]
    var schedule: Schedule
    var table: Table
    var homeAdvantage: Double
    var averageGoalsAmount: Double

    var nextMatchDayIndex = 0
    var isSeasonOver = false

    init(
        withHomeAdvantage homeAdvantage: Double = 1.20,
        withAvarageGoalsAmount avarageGoalsAmount: Double = 1.10
    ) {
        let teamList = loadDefaultTeams()
        let table = Table(with: teamList)

        precondition(
            !teamList.isEmpty && teamList.count.isMultiple(of: 2),
            "Provided Team list is not valid"
        )

        self.teams = teamList
        self.schedule = Schedule(for: teamList)
        self.table = table
        self.homeAdvantage = homeAdvantage
        self.averageGoalsAmount = avarageGoalsAmount
    }

    func simulateLeague() {
        precondition(self.isSeasonOver == false, "Season should not be over")

        for _ in self.nextMatchDayIndex..<schedule.matchDayList.count {
            simulateNextMatchDay()
        }

        self.isSeasonOver = true
    }

    func simulateNextMatchDay() {
        precondition(self.isSeasonOver == false, "Season should not be over")

        for j in schedule.matchDayList[nextMatchDayIndex].indices {
            let matchResult = schedule.matchDayList[nextMatchDayIndex][j]
                .simulate(
                    withHomeAdvantage: homeAdvantage,
                    averageGoalsAmount: averageGoalsAmount
                )
            let simulatedMatch = schedule.matchDayList[nextMatchDayIndex][j]

            table
                .tableRows[simulatedMatch.homeTeam]?
                .recordStats(
                    playingHome: true,
                    matchOutcome: matchResult.outcome,
                    goalsScored: matchResult.homeTeamGoals,
                    goalsAgainst: matchResult.awayTeamGoals
                )
            table
                .tableRows[simulatedMatch.awayTeam]?
                .recordStats(
                    playingHome: false,
                    matchOutcome: matchResult.outcome,
                    goalsScored: matchResult.awayTeamGoals,
                    goalsAgainst: matchResult.homeTeamGoals
                )
        }

        self.nextMatchDayIndex += 1
        if self.nextMatchDayIndex == self.schedule.matchDayList.count {
            self.isSeasonOver = true
        }
    }

    func reset() {
        let table = Table(with: teams)
        let schedule = Schedule(for: teams)

        self.table = table
        self.schedule = schedule
        self.nextMatchDayIndex = 0
        self.isSeasonOver = false
    }
}

func loadDefaultTeams() -> [Team] {
    let baseTeams = [
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

    let attackAverage = calculateAverageStrength(for: baseTeams, using: .attack)
    let defenseAverage = calculateAverageStrength(
        for: baseTeams,
        using: .defense
    )

    /// The factor used to spread team values to achieve more realistic results
    let k = 1.8

    var teams: [Team] = []

    for team in baseTeams {
        teams.append(
            team
                .withStrength(
                    offensive: attackAverage + k
                        * (team.attack - attackAverage),
                    defensive: defenseAverage + k
                        * (team.defense - defenseAverage)
                )
        )
    }

    return teams
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
