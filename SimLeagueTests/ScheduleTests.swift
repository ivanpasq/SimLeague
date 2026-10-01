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

        let generatedSchedule = await league.schedule.matchDayList
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

    @Test func scheduleForTeamShouldReturnMatchForGivenTeam() async throws {
        let league = await League()

        let teams = await league.teams

        let testTeam = try #require(teams.first)

        let teamSchedule = await league.schedule.matches(for: testTeam)

        for schedule in teamSchedule {
            #expect(
                schedule.match.homeTeam == testTeam
                    || schedule.match.awayTeam == testTeam,
                "Tested team is not in the retrieved match"
            )
        }

        #expect(
            teamSchedule.count == (teams.count - 1) * 2,
            "Team schedule: got \(teamSchedule.count), expected \((teams.count - 1) * 2) "
        )
    }

    @Test func scheduleForTeamNotExistentShouldBeEmpty() async {
        let league = await League()

        let teamA = Team(name: "Test Not Existent", attack: 80, defense: 80)
        let teamNotExistentSchedule = await league.schedule.matches(for: teamA)

        #expect(
            teamNotExistentSchedule.count == 0,
            "Schedule for not existent team should be empty"
        )
    }

    @Test func matchDayIndexInScheduleForMethodIsCoherent() async throws {
        let teamA = Team(name: "TeamA", attack: 80, defense: 80)
        let teamB = Team(name: "TeamB", attack: 80, defense: 80)
        let teamC = Team(name: "TeamC", attack: 80, defense: 80)
        let teamD = Team(name: "TeamD", attack: 80, defense: 80)

        let teamList = [teamA, teamB, teamC, teamD]
        let schedule = Schedule(for: teamList)

        let teamASchedule = schedule.matches(for: teamA)
        var matchDayIndexExpected = 0

        for matchDay in teamASchedule {
            #expect(
                matchDay.matchDayIndex == matchDayIndexExpected,
                "Match Day index, got \(matchDay.matchDayIndex), expected \(matchDayIndexExpected)"
            )
            matchDayIndexExpected += 1
        }

        #expect(
            teamASchedule.count == (teamList.count - 1) * 2,
            "Total number of games, got \(schedule.matchDayList.count), expected \((teamList.count-1)*2)"
        )
    }

}
