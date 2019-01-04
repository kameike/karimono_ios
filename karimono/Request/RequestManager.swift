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
    let onSucess: (T) -> Void
    let onError: (KarimonoRequestError) -> Void
}

struct Empty: Codable {
}

struct RequestHandlerProvider {
    static let shared = RequestHandlerProvider.init(
        // getRequest: StubBorrwingItemsHandlaber()
        getRequest: RequestManager.shared
    )

    let getRequest: GetBorrwingItemsHandlable
}

enum RequestType {
    case get
    case post
    case put
    case delete

    var toString: String {
        switch self {
        case .get:  return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}

protocol RequestBase: RequestDescriable {}

extension RequestBase {
    var host: String {
        return  "https://karimono.kameike.net"
    }

    var contentType: String {
        return "application/json"
    }

    var accept: String {
        return "application/json"
    }
}

protocol RequestDescriable {
    associatedtype Body: Encodable
    associatedtype Response: Decodable

    var requestType: RequestType {get}
    var host: String { get }
    var contentType: String { get }
    var accept: String { get }
    var payload: Body { get }
    var path: String { get }
}

struct BorrowingItemRequest: RequestBase {
    let payload: Borrowing

    let requestType: RequestType = .post
    let path = "items/borrow"
    typealias Response = Empty
    typealias Body = Borrowing
}

class RequestManager {
    let host: String

    init (host: String) {
        self.host = host
    }

    static let shared = RequestManager(host: "https://karimono.kameike.net")

    func borrowItem(_ borrowing: Borrowing) {
        let result = try! JSONEncoder().encode(borrowing)

        var request = URLRequest(url: URL(string: "\(host)/items/borrow")!)
        request.httpBody = result
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { _, _, _ in

        }.resume()
    }

    func getItems(_ handler: @escaping ([Borrowing]) -> Void) {
        var request = URLRequest(url: URL(string: "\(host)/items")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, _ in
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

        URLSession.shared.dataTask(with: request) { _, _, _ in

        }.resume()
    }
}
