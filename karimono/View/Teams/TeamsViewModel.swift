//
//  TeamsViewModel.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation
import RxCocoa

class TeamsViewModel: BaseViewModel, RepositoryInjectable {
    var repository: Repositable!
    var teams = BehaviorRelay<[Team]>(value: [])

    func fetch() {
        let req = repository.getTeams(GetTeamsRequest(payload: Empty())).publish()

        bindLoading(req.map { $0.generalState })
        bindShowErrorMessage(req.map { $0.generalState })

        req.flatMap{ $0.observeComplete }
            .map { $0.teams }
            .asDriver(onErrorJustReturn: [])
            .drive(teams)
            .disposed(by: bag)

        req.connect().disposed(by: bag)
    }

}

