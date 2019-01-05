//
//  AccountTeamRequest.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation

struct CreateTeamRequestData: Codable {
    let name: String
    let password: String
}

struct JoinTeamRequestData: Codable {
    let name: String
    let password: String
}

struct JoinOrCreateResponse: Codable {
    let team: Team
}

struct GetTeamsRespose: Codable {
    let teams: [Team]
}

struct CreateTeamRequest: RequestBase {
    typealias Body = CreateTeamRequestData
    typealias Response = JoinOrCreateResponse

    let payload: CreateTeamRequestData
    let method: RequestMethod = .post
    let path: String = "teams"
}

struct JoinTeamRequest: RequestBase {
    typealias Body = JoinTeamRequestData
    typealias Response = JoinOrCreateResponse

    let payload: JoinTeamRequestData
    let method: RequestMethod = .post
    let path: String = "teams/menbers"
}

struct GetTeamsRequest: RequestBase {
    typealias Body = Empty
    typealias Response = GetTeamsRespose

    let payload: Empty
    let method: RequestMethod = .get
    let path: String = "teams"
}
