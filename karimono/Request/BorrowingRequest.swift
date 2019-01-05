//
//  BorrowingRequest.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation

struct BorrowingItemRequest: RequestBase {
    let payload: Borrowing

    let method: RequestMethod = .post
    let path = "items/borrow"
    typealias Response = Empty
    typealias Body = Borrowing
}
