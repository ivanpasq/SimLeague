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
    var schedule: [[Match]]
    var table: Table
    var homeAdvantage: Double
    var averageGoalsAmount: Double

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
        self.schedule = generateSchedule(for: teamList)
        self.table = table
        self.homeAdvantage = homeAdvantage
        self.averageGoalsAmount = avarageGoalsAmount
    }

    func simulateLeague() {
        reset()
        
        for i in schedule.indices {
            for j in schedule[i].indices {
                let matchResult = schedule[i][j].simulate(
                    withHomeAdvantage: homeAdvantage,
                    averageGoalsAmount: averageGoalsAmount
                )
                let simulatedMatch = schedule[i][j]

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
        }
    }
    
    func reset() {
        let table = Table(with: teams)
        let schedule = generateSchedule(for: teams)
        
        self.table = table
        self.schedule = schedule
    }
}

func generateSchedule(for teamList: [Team]) -> [[Match]] {
    var tempTeamsArray = teamList
    tempTeamsArray.shuffle()
    
    let gameCount = teamList.count - 1
    var firstLegs: [[Match]] = []
    var secondLegs: [[Match]] = []
    
    for _ in 0..<gameCount {
        var firstLegMatchDay: [Match] = []
        var returnLegMatchDay: [Match] = []
        for j in 0..<(teamList.count / 2) {
            firstLegMatchDay
                .append(
                    Match(
                        homeTeam: tempTeamsArray[j],
                        awayTeam: tempTeamsArray[gameCount - j]
                    )
                )
            returnLegMatchDay
                .append(
                    Match(
                        homeTeam: tempTeamsArray[gameCount - j],
                        awayTeam: tempTeamsArray[j]
                    )
                )
        }
        firstLegs.append(firstLegMatchDay)
        secondLegs.append(returnLegMatchDay)
        
        tempTeamsArray.append(tempTeamsArray.remove(at: 1))
    }
    
    var schedule = firstLegs + secondLegs
    
    for i in stride(from: 0, to: gameCount, by: 2) {
        schedule.swapAt(i, i + gameCount)
    }
    
    return schedule
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
    let defenseAverage = calculateAverageStrength(for: baseTeams, using: .defense)
    
    /// The factor used to spread team values to achieve more realistic results
    let k = 1.8
    
    var teams: [Team] = []
    
    for team in baseTeams {
        teams.append(
            team
                .withStrength(
                    offensive: attackAverage + k * (team.attack - attackAverage),
                    defensive: defenseAverage + k * (team.defense - defenseAverage)
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
