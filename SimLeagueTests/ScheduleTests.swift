//
//  ScheduleTests.swift
//  SimLeagueTests
//
//  Created by Ivan Pasquariello on 24/08/2026.
//

import Testing

@testable import SimLeague

struct ScheduleTests {

    @Test func generatedScheduleShouldAdhereToRules() async {
        let league = await League()

        let generatedSchedule = await league.schedule
        let teams = await league.teams

        #expect(
            generatedSchedule.count == (teams.count - 1) * 2,
            "Number of legs should be equal to the double of the team count less one"
        )

        var checkHomeGamesPerTeam = [Team: Int]()
        var checkAwayGamesPerTeam = [Team: Int]()

        for leg in generatedSchedule {
            #expect(
                leg.count == teams.count / 2,
                "Games per leg should be half the teams count"
            )

            var teamListCheck = Set<Team>()

            for game in leg {
                let homeTeam = game.homeTeam
                let (homeOk, homeInsertedTeam) = teamListCheck.insert(homeTeam)
                #expect(
                    homeOk,
                    "Team \(homeTeam.name) should appear only once in a leg"
                )
                checkHomeGamesPerTeam[homeInsertedTeam, default: 0] += 1

                let awayTeam = game.awayTeam
                let (awayOk, awayInsertedTeam) = teamListCheck.insert(awayTeam)
                #expect(
                    awayOk,
                    "Team \(awayTeam.name) should appear only once in a leg"
                )
                checkAwayGamesPerTeam[awayInsertedTeam, default: 0] += 1
            }

            #expect(
                teamListCheck.count == teams.count,
                "Teams in the leg should be the same number as the team in the League"
            )
        }

        for team in teams {
            #expect(
                checkHomeGamesPerTeam[team] == teams.count - 1,
                "Home matches per team \(team.name) should be \(teams.count - 1)"
            )
            #expect(
                checkAwayGamesPerTeam[team] == teams.count - 1,
                "Away matches per team \(team.name) should be \(teams.count - 1)"
            )
        }
    }

}
