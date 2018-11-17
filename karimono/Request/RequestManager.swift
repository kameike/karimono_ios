//
//  RequestHandler.swift
//  karimono
//
//  Created by Kei Kameda on 2018/11/17.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import Foundation


struct Borrowing: Codable {
    let user: String
    let item: String
}

struct Returning: Codable {
    let item: String
}

struct KarimonoRequestError: Codable {
    let reason: String
}

struct RequestHandler<T> {
    let onSucess: (T) -> ()
    let onError: (KarimonoRequestError) -> ()
}



struct RequestHandlerProvider {
    static let shared = RequestHandlerProvider.init(
        // getRequest: StubBorrwingItemsHandlaber()
        getRequest: RequestManager.shared
    )

    let getRequest: GetBorrwingItemsHandlable
}

class RequestManager {
    let host: String

    init (host: String) {
        self.host = host
    }

    static let shared = RequestManager(host:  "https://karimono.kameike.net")

    func borrowItem(_ borrowing: Borrowing) {
        let result = try! JSONEncoder().encode(borrowing)

        var request = URLRequest(url: URL(string: "\(host)/items/borrow")!)
        request.httpBody = result
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, err in

        }.resume()
    }

    func getItems(_ handler: @escaping ([Borrowing]) -> ()) {
        var request = URLRequest(url: URL(string: "\(host)/items")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, err in
            guard let data = data else {
                return
            }
            let result = try! JSONDecoder().decode([Borrowing].self, from: data)

            handler(result.reversed())
            }.resume()
    }

    func returnItem(_ item: Returning) {
        let result = try! JSONEncoder().encode(item)

        var request = URLRequest(url: URL(string: "\(host)/items/return")!)
        request.httpBody = result
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, err in

        }.resume()
    }
}
