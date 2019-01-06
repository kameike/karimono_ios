//
//  BaseViewModel.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import RxSwift
import RxCocoa


class BaseViewModel: NSObject, RequestStateHoldable {
    let bag = DisposeBag()
    var requestNeedShowLoading = BehaviorRelay<Bool>(value: false)
    var errorNeedShowModal = BehaviorRelay<KarimonoRequestError?>(value: nil)

    func bindLoading(_ stateObservable: Observable<RequestStateWithoutType>) {
        stateObservable
            .map { $0.isLoading }
            .asDriver(onErrorJustReturn: false)
            .drive(requestNeedShowLoading)
            .disposed(by: bag)
    }

    func bindShowErrorMessage(_ stateObservable: Observable<RequestStateWithoutType>) {
        stateObservable
            .flatMap { $0.observeError }
            .map { $0 as Optional<KarimonoRequestError> }
            .asDriver(onErrorJustReturn: nil)
            .drive(errorNeedShowModal)
            .disposed(by: bag)
    }
}

