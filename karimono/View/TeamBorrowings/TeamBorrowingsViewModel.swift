//
//  TeamBorrowingViewModel.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/06.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TeamBorrowingViewModel: BaseViewModel, RepositoryInjectable {
    var repository: Repositable!
    let team: Team
    let items = BehaviorRelay<[Borrowing]>(value: [])
    let returnCompleteRelay = PublishRelay<Borrowing>()

    init(team: Team) {
        self.team = team
        super.init()
    }

    func fetch() {
        let req = repository.getTeamBorrowing(GetTeamBorrowingItemRequest.init(id: team.id)).publish()

        bindLoading(req.map { $0.generalState })
        bindShowErrorMessage(req.map{ $0.generalState })

        req.flatMap{ $0.observeComplete }
            .map { $0.borrowings }
            .asDriver(onErrorJustReturn: [])
            .drive(items)
            .disposed(by: bag)

        req.connect().disposed(by: bag)
    }

    func returnBorrowing(_ borrowing: Borrowing) {
        let req = repository.returnBorrowing(borrowing).publish()

        bindLoading(req.map { $0.generalState })
        bindShowErrorMessage(req.map { $0.generalState })

        req.flatMap{ $0.observeComplete }
            .map{ $0.borrowing }
            .observeOn(MainScheduler.instance)
            .bind(to: returnCompleteRelay)
            .disposed(by: bag)

        req.connect().disposed(by: bag)
    }
}
