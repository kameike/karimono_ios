//
//  GetBorrowingListRequest.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/09.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import Foundation


struct AuthRequestData: Codable {
    let name: String
    let password: String
}

struct AccountAuthResponse: Codable {
    let accessToken: String
    let account: Account
}

enum AccountAuthRequestType {
    case signIn
    case signUp
}

struct AccountValidationRquestData: Codable {
    let name: String
}

struct AccountValidationResponse: Codable {
    let available: Bool
}

struct AccountValidationRquest: RequestBase {
    typealias Body = AccountValidationRquestData
    typealias Response = AccountValidationResponse

    let payload: AccountValidationRquestData
    let method: RequestMethod = .post
    let path: String = "account/validation"
}

struct AccountAuthorizeRequest: RequestBase {
    typealias Response = AccountAuthResponse
    typealias Body = AuthRequestData

    var payload: AuthRequestData
    var path: String {
        switch requestType {
        case .signUp:
            return "account"
        case .signIn:
            return "token"
        }
    }
    let method: RequestMethod = .post
    let requestType: AccountAuthRequestType
}
