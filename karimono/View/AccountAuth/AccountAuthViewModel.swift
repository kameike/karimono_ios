//
//  AccountAuthViewModel.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import RxSwift
import RxCocoa

class AccountAuthViewModel: BaseViewModel, RepositoryInjectable {
    var repository: Repositable!
    let authorizeType: AccountAuthRequestType

    let nameBinder = BehaviorRelay<String?>(value: nil)
    let passBinder = BehaviorRelay<String?>(value: nil)

    let canSubmitBehavior = BehaviorRelay<Bool>(value: false)
    let canClosePublish = BehaviorRelay<Bool>(value: false)
    let accountValidationStatus = BehaviorRelay<AccountNameValidationStatus>(value: .none)

    enum AccountNameValidationStatus {
        case none
        case loading
        case valid
        case invalid
    }

    init(authorizeType: AccountAuthRequestType) {
        self.authorizeType = authorizeType
        super.init()

        Observable.combineLatest(nameBinder.asObservable(), passBinder.asObservable())
            .map { $0.0 != "" && $0.1 != "" }
            .bind(to: canSubmitBehavior)
            .disposed(by: bag)

        nameBinder
            .map { _ in return AccountNameValidationStatus.none }
            .asDriver(onErrorJustReturn: .none)
            .drive(accountValidationStatus)
            .disposed(by: bag)

        nameBinder.asObservable()
            .flatMap{ Observable.from(optional: $0) }
            .debounce(0.3, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] name in self?.checkName(name) })
            .disposed(by: bag)
    }

    var name: String {
        return nameBinder.value ?? ""
    }

    var passowrd: String {
        return passBinder.value ?? ""
    }

    func checkName(_ name: String) {
        guard name != "" else {
            return
        }

        guard authorizeType == .signUp else {
            return
        }

        let req = repository.checkName(AccountValidationRquest.init(payload: AccountValidationRquestData.init(name: name))).publish()

        req.flatMap { $0.observeComplete }
            .map { $0.available ? AccountNameValidationStatus.valid : AccountNameValidationStatus.invalid }
            .asDriver(onErrorJustReturn: .none)
            .drive(accountValidationStatus)
            .disposed(by: bag)

        accountValidationStatus.accept(.loading)
        req.connect().disposed(by: bag)
    }

    func executeAuth() {
        let auth = AuthRequestData.init(name: name, password: passowrd)
        var res: LongAsyncData<AccountAuthResponse>!

        switch authorizeType {
        case .signIn:
            res = repository.singIn(auth)
        case .signUp:
            res = repository.singUp(auth)
        }
        let cold = res.publish()

        bindLoading(cold.map{ $0.generalState })
        bindShowErrorMessage(cold.map{ $0.generalState })
        
        cold.asObservable()
            .flatMap{ $0.observeComplete }
            .do(onNext:{ [weak self] v in
                self?.registerAuthInfo(v)
            })
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
            .drive(canClosePublish)
            .disposed(by: bag)

        cold.connect().disposed(by: bag)
    }

    func registerAuthInfo(_ response: AccountAuthResponse) {
        repository.registerAccountAuth(response)
    }
}
