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

struct BorrowingResponse: Codable {
    let borrowing : Borrowing
}

struct GetTeamBorrowingsResponse: Codable {
    let borrowings: [Borrowing]
}

struct GetTeamBorrowingItemRequest: RequestBase {
    typealias Response = GetTeamBorrowingsResponse
    typealias Body = Empty
    let payload = Empty()

    let method: RequestMethod = .get
    let id: Int
    var path: String {
        return "teams/\(id)/borrowings"
    }
}

struct NewBorrowingRequest: RequestBase {
    typealias Body = BorrowingRequestData
    typealias Response = Borrowing

    let payload: BorrowingRequestData
    let path: String  = "borrowings"

    let method: RequestMethod = .post
}

struct BorrowingItemRequest: RequestBase {
    typealias Response = Empty
    typealias Body = BorrowingRequestData

    let payload: BorrowingRequestData

    let method: RequestMethod = .post
    let path = "borrowings"
}
