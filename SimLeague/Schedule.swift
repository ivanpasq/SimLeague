//
//  Schedule.swift
//  SimLeague
//
//  Created by Ivan Pasquariello on 30/09/2026.
//

import Foundation

struct Schedule {
    var matchDayList: [[Match]]

    init(for teamList: [Team]) {
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

        self.matchDayList = schedule
    }

    func matches(for team: Team) -> [TeamMatchDay] {
        var result: [TeamMatchDay] = []
        var matchDayIndex = 0

        for matchDay in self.matchDayList {
            if let teamMatch = matchDay.first(where: { match in
                match.homeTeam == team || match.awayTeam == team
            }) {
                result
                    .append(
                        TeamMatchDay(
                            match: teamMatch,
                            matchDayIndex: matchDayIndex
                        )
                    )
            }

            matchDayIndex += 1
        }

        return result
    }
}

struct TeamMatchDay {
    let match: Match
    let matchDayIndex: Int
}
