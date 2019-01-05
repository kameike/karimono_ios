//
//  WelcomeViewModel.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import RxSwift
import RxCocoa

class WelcomeViewModel: BaseViewModel, RepositoryInjectable {
    var repository: Repositable!

    let passwordBinder = BehaviorRelay<String?>(value: nil)
    let nameBinder = BehaviorRelay<String?>(value: nil)

    var isNeedKeepShowing: Bool {
        return !repository.hasLogin()
    }
}
