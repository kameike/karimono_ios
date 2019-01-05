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

    func registerAccountAuth(_ authData: AccountAuthResponse)
    func getMe() -> Account
    func hasLogin() -> Bool
    func deleteLogin()
}

class DataRepository: Repositable {
    let executor: RequestExecutable
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

    func registerAccountAuth(_ authData: AccountAuthResponse)  {
        print("register \(authData)")
        UserDefaults.standard.set(authData.accessToken, forKey: accessTokenKey)
        UserDefaults.standard.set(authData.account.id, forKey: accountIdKey)
        UserDefaults.standard.set(authData.account.name, forKey: accountNameKey)
    }

    private func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }

    func getMe() -> Account {
        guard let name = UserDefaults.standard.string(forKey: accountNameKey) else {
            fatalError()
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
}