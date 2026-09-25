//
//  LeagueTests.swift
//  SimLeagueTests
//
//  Created by Ivan Pasquariello on 25/08/2026.
//

import Testing

@testable import SimLeague

struct LeagueTests {

    @Test func checkSimulatedLeague() async {
        let league = await League()
        await league.simulateLeague()

        let finalStandings = await league.table.tableRows
        let leagueTeams = await league.teams
        let totalGoalsScored = finalStandings.values.reduce(
            0,
            { sum, stats in sum + stats.totalStats.goalsScored }
        )
        let totalGoalsAgainst = finalStandings.values.reduce(
            0,
            { sum, stats in sum + stats.totalStats.goalsAgainst }
        )
        let isSeasonOver = await league.isSeasonOver

        #expect(
            totalGoalsScored == totalGoalsAgainst,
            "Goals scored in the season should be the same as goals against"
        )

        let totalPoints = finalStandings.values.reduce(
            0,
            { sum, stats in sum + stats.totalStats.points }
        )

        #expect(
            totalPoints > 760 && totalPoints < 1140,
            "Total points should be in a proper range"
        )

        for row in finalStandings {
            #expect(
                row.value.totalStats.games == (leagueTeams.count - 1) * 2,
                "Team \(row.key.name) should have played \((leagueTeams.count - 1) * 2) games"
            )
        }

        #expect(
            isSeasonOver,
            "After simulate the league, season should be over"
        )
    }

    @Test func simulateMatchDayShouldSimOneMatchDay() async {
        let league = await League()

        let startingNextMatchDayIndex = await league.nextMatchDayIndex
        await league.simulateNextMatchDay()
        let newNextMatchDayIndex = await league.nextMatchDayIndex
        let firstGameOfTheSeason = await league.schedule[
            startingNextMatchDayIndex
        ].first?.matchResult

        #expect(
            newNextMatchDayIndex - startingNextMatchDayIndex == 1,
            "SimulateNextMatchDay should increment nextMatchDayIndex by one"
        )
        #expect(
            firstGameOfTheSeason != nil,
            "simulateNextMatchDay should have simmed the first match day"
        )
    }
}
