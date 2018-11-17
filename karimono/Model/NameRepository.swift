//
//  NameRepository.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/08.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import Foundation

class NameRepository {
    static let sheard = NameRepository()

    var name: String {
        return _name!
    }

    var hasName: Bool {
        return _name != nil
    }

    func setName(_ name: String) {
        _name = name
    }

    private var _name: String?
}
