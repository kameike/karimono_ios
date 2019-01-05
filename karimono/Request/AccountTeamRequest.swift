//
//  AccountTeamRequest.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation

struct AuthTeamRequestData: Codable {
    let name: String
    let password: String
}

struct AuthTeamResponse: Codable {
    let team: Team
}

struct GetTeamsRespose: Codable {
    let teams: [Team]
}

enum TeamAuthType {
    case create
    case join
}

struct AuthTeamRequest: RequestBase {
    typealias Body = AuthTeamRequestData
    typealias Response = AuthTeamResponse

    let payload: AuthTeamRequestData
    let method: RequestMethod = .post
    let authType: TeamAuthType
    var path: String {
        switch authType {
        case .create: return "team"
        case .join: return "team/menbers"
        }
    }
}

struct GetTeamsRequest: RequestBase {
    typealias Body = Empty
    typealias Response = GetTeamsRespose

    let payload: Empty
    let method: RequestMethod = .get
    let path: String = "teams"
}
