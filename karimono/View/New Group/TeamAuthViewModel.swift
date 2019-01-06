//
//  TeamAuthViewModel.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import RxSwift
import RxCocoa

class TeamAuthViewModel: BaseViewModel, RepositoryInjectable {
    var repository: Repositable!
    let authType: TeamAuthType

    let nameBinder = BehaviorRelay<String?>(value: nil)
    let passwordBinder = BehaviorRelay<String?>(value: nil)
    let teamNameAvailability = BehaviorRelay<checkTeamNameState>(value: .none)

    let canSubmit = BehaviorRelay<Bool>(value: false)
    let canClose = PublishRelay<Void>()

    enum checkTeamNameState {
        case none
        case loading
        case available
        case unavailable
    }

    init(authType: TeamAuthType) {
        self.authType = authType
        super.init()

        Observable.combineLatest(nameBinder.asObservable(), passwordBinder.asObservable())
            .map{ $0.0 != "" && $0.1 != "" }
            .bind(to: canSubmit)
            .disposed(by: bag)

        nameBinder
            .debounce(0.4, scheduler: MainScheduler.instance)
            .flatMap { Observable.from(optional: $0) }
            .bind(onNext: { [weak self] value in
                self?.checkTeamNameAvalability(value)
            })
            .disposed(by: bag)

    }

    func submit() {
        let name = nameBinder.value ?? ""
        let pass = passwordBinder.value ?? ""
        guard name != "" else {
            return
        }
        guard pass != "" else {
            return
        }

        let data = AuthTeamRequestData.init(name: name, password: pass)
        var req: LongAsyncData<TeamAuthRequest.Response>!

        switch authType {
        case .create:
            req = repository.createTeam(data)
        case .join:
            req = repository.joinTeam(data)
        }
        let cold = req.publish()

        bindLoading(cold.map { $0.generalState })
        bindShowErrorMessage(cold.map { $0.generalState })

        cold
            .flatMap{ $0.observeComplete }
            .map { _ in (()) }
            .bind(to: canClose)
            .disposed(by: bag)

        cold.connect().disposed(by: bag)
    }

    func checkTeamNameAvalability(_ name: String) {

    }
}
