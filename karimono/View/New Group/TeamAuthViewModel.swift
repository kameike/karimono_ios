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

    init(authType: TeamAuthType) {
        self.authType = authType
        super.init()
    }
}
