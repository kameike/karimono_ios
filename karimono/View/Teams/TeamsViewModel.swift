//
//  TeamsViewModel.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation

class TeamsViewModel: BaseViewModel, RepositoryInjectable {
    var repository: Repositable!

    func fetch() {
        let req = repository.getTeams(GetTeamsRequest(payload: Empty())).publish()

        bindLoading(req.map { $0.generalState })
        bindShowErrorMessage(req.map { $0.generalState })

        req.connect().disposed(by: bag)
    }
}
