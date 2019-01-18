//
//  NewBorrowingViewModel.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/06.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class NewBorrwoingViewModel: BaseViewModel, RepositoryInjectable {
    var repository: Repositable!

    let teamNameBinder = BehaviorRelay<String>(value: "")
    let itemNameBinder = BehaviorRelay<String>(value: "")
    let memoBinder = BehaviorRelay<String>(value: "")

    let borrowComplete = PublishRelay<Borrowing>()

    init(itemName: String, teamName: String?, memo: String?) {
        teamNameBinder.accept(teamName ?? "")
        itemNameBinder.accept(itemName)
        memoBinder.accept(memo ?? "")
    }

    func submit() {
        let req = repository.newBorrowing(NewBorrowingRequest.init(payload:BorrowingRequestData.init(item: itemNameBinder.value, memo: memoBinder.value, teamName: teamNameBinder.value))).publish()

        bindLoading(req.map { $0.generalState })
        bindShowErrorMessage(req.map { $0.generalState })

        req.flatMap { $0.observeComplete }
            .map { $0.borrowing }
            .observeOn(MainScheduler.instance)
            .bind(to: borrowComplete)
            .disposed(by: bag)

        req.connect()
            .disposed(by: bag)
    }
}
