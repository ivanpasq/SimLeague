//
//  TeamTests.swift
//  SimLeagueTests
//
//  Created by Ivan Pasquariello on 26/08/2026.
//

import Testing

@testable import SimLeague

struct TeamTests {

    @Test func withStrengthShouldUpdateTeamWithoutCreatingNewOnes() {
        let teamA = Team(name: "TeamA", attack: 99, defense: 99)
        let teamA_afterUpdate = teamA.withStrength(offensive: 50, defensive: 50)

        #expect(
            teamA == teamA_afterUpdate,
            "Comparing original team to updated one should be true"
        )
    }

}
