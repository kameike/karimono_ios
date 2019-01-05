//
//  ApiModels.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation


struct Borrowing: Codable {
    let user: String
    let item: String
}

struct Returning: Codable {
    let item: String
}

struct Team: Codable {
    let name: String
    let id: Int
}

struct Account: Codable {
    let name: String
    let id: Int
}

struct RequestHandler<T> {
    let onSucess: (T) -> Void
    let onError: (KarimonoRequestError) -> Void
}

struct Empty: Codable {
}
