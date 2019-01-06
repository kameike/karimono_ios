//
//  BorrowingRequest.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation

struct BorrowingRequestData: Codable {
    let item: String
    let memo: String
    let teamName: String
}

struct BorrowingItemRequest: RequestBase {
    typealias Response = Empty
    typealias Body = BorrowingRequestData

    let payload: BorrowingRequestData

    let method: RequestMethod = .post
    let path = "items/borrowings"
}
