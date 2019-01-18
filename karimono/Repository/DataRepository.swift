//
//  RequestRepository.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import RxSwift

typealias LongAsyncData<T> = Observable<RequestState<T>>
typealias ShortAsyncData<T> = Observable<RequestState<T>>

protocol Repositable {
    func singIn(_ payload: AuthRequestData) -> LongAsyncData<AccountAuthorizeRequest.Response>
    func singUp(_ payload: AuthRequestData) -> LongAsyncData<AccountAuthorizeRequest.Response>
    func checkName(_ payload: AccountValidationRquest) -> LongAsyncData<AccountValidationRquest.Response>

    func getTeams(_ payload: GetTeamsRequest) -> LongAsyncData<GetTeamsRequest.Response>
    func createTeam(_ payload: AuthTeamRequestData) -> LongAsyncData<TeamAuthRequest.Response>
    func joinTeam(_ payload: AuthTeamRequestData) -> LongAsyncData<TeamAuthRequest.Response>

    func getTeamBorrowing(_ payload: GetTeamBorrowingItemRequest) -> LongAsyncData<GetTeamBorrowingItemRequest.Response>
    func newBorrowing(_ payload: NewBorrowingRequest) -> LongAsyncData<NewBorrowingRequest.Response>
    func returnBorrowing(_ payload: Borrowing) -> LongAsyncData<ReturnBorrowingRequest.Response>

    func registerAccountAuth(_ authData: AccountAuthResponse)
    func getMe() -> Account?
    func hasLogin() -> Bool
    func deleteLogin()
}

class DataRepository: Repositable {


    let executor: RequestExecutable
    let secureTokenKey = "x-karimono-token"
    private let accessTokenKey = "accessTokenKey"
    private let accountNameKey = "accountName"
    private let accountIdKey = "accountId"

    init(executor: RequestExecutable) {
        self.executor = executor
    }

    func singIn(_ payload: AuthRequestData) -> LongAsyncData<AccountAuthorizeRequest.Response> {
        let req = AccountAuthorizeRequest.init(payload: payload, requestType: .signIn)
        return executor.execRequest(handler: req, addtionalHeader: [:])
    }

    func singUp(_ payload: AuthRequestData) -> LongAsyncData<AccountAuthorizeRequest.Response> {
        let req = AccountAuthorizeRequest.init(payload: payload, requestType: .signUp)
        return executor.execRequest(handler: req, addtionalHeader: [:])
    }

    func createTeam(_ payload: AuthTeamRequestData) -> LongAsyncData<TeamAuthRequest.Response> {
        let req = TeamAuthRequest.init(payload: payload, authType: .create)
        return executor.execRequest(handler: req, addtionalHeader: requestToken)
    }
    func joinTeam(_ payload: AuthTeamRequestData) -> LongAsyncData<TeamAuthRequest.Response> {
        let req = TeamAuthRequest.init(payload: payload, authType: .join)
        return executor.execRequest(handler: req, addtionalHeader: requestToken)
    }

    func registerAccountAuth(_ authData: AccountAuthResponse)  {
        print("register \(authData)")
        UserDefaults.standard.set(authData.accessToken, forKey: accessTokenKey)
        UserDefaults.standard.set(authData.account.id, forKey: accountIdKey)
        UserDefaults.standard.set(authData.account.name, forKey: accountNameKey)
    }

    private func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }

    func getMe() -> Account? {
        guard let name = UserDefaults.standard.string(forKey: accountNameKey) else {
           return nil
        }
        let id = UserDefaults.standard.integer(forKey: accountIdKey)
        return Account(name: name, id: id)
    }

    func hasLogin() -> Bool {
        return UserDefaults.standard.string(forKey: accessTokenKey ) != nil
    }

    func deleteLogin() {
        UserDefaults.standard.removeObject(forKey: accountIdKey)
        UserDefaults.standard.removeObject(forKey: accountNameKey)
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
    }

    func getTeams(_ payload: GetTeamsRequest) -> LongAsyncData<GetTeamsRequest.Response> {
        return executor.execRequest(handler: payload, addtionalHeader: requestToken)
    }

    var requestToken: [String: String] {
        guard let token = getAccessToken() else {
            return [:]
        }
        return [secureTokenKey: token]
    }

    func checkName(_ payload: AccountValidationRquest) -> LongAsyncData<AccountValidationRquest.Response> {
        return executor.execRequest(handler: payload, addtionalHeader: [:])
    }

    func getTeamBorrowing(_ payload: GetTeamBorrowingItemRequest) -> LongAsyncData<GetTeamBorrowingItemRequest.Response> {
        return executor.execRequest(handler: payload, addtionalHeader: requestToken)
    }

    func newBorrowing(_ payload: NewBorrowingRequest) -> LongAsyncData<NewBorrowingRequest.Response> {
        return executor.execRequest(handler: payload, addtionalHeader: requestToken)
    }

    func returnBorrowing(_ payload: Borrowing) -> LongAsyncData<ReturnBorrowingRequest.Response> {
        return executor.execRequest(handler: ReturnBorrowingRequest.init(borrowing: payload), addtionalHeader: requestToken)
    }
}
