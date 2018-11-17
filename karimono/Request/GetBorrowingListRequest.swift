//
//  GetBorrowingListRequest.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/09.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import Foundation

protocol GetBorrwingItemsHandlable: class {
    func getBorrwingItems(handler: RequestHandler<[Borrowing]>)
}

class StubBorrwingItemsHandlaber: GetBorrwingItemsHandlable {
    func getBorrwingItems(handler: RequestHandler<[Borrowing]>) {
        DispatchQueue(label: "requestStub").async {
            usleep(500 * 1000) // sleep 500ms
            if Int.random(in: 0...10) <= 3 {
                DispatchQueue.main.async {
                    handler.onError(KarimonoRequestError.init(reason: "通信エラーが発生しました"))
                }
            } else {
                DispatchQueue.main.async {
                    var result:[Borrowing] = []
                    for _ in 0...Int.random(in: 1...3) {
                        result.append(Borrowing(user: UUID().uuidString, item: "スタブのアイテム"))
                    }
                    handler.onSucess(result)
                }
            }

        }
    }
}

extension RequestManager: GetBorrwingItemsHandlable {
    func getBorrwingItems(handler: RequestHandler<[Borrowing]>) {
        var request = URLRequest(url: URL(string: "\(host)/items")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
                if let err = err as? URLError {
                    if err.code == URLError.timedOut {
                        DispatchQueue.main.async {
                            handler.onError(KarimonoRequestError.init(reason: "接続状況が悪いです"))
                        }
                        return
                    }

                    if err.code == URLError.notConnectedToInternet {
                        DispatchQueue.main.async {
                            handler.onError(KarimonoRequestError.init(reason: "インターネットがオフラインのようです"))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        handler.onError(KarimonoRequestError.init(reason: "通信エラー: \(err.code.rawValue)"))
                    }
                    return
                }
                DispatchQueue.main.async {
                    handler.onError(KarimonoRequestError.init(reason: "通信エラー"))

                }
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    handler.onError(KarimonoRequestError.init(reason: "通信エラー"))
                }
                return
            }

            if response.statusCode >= 500 {
                DispatchQueue.main.async {
                    handler.onError(KarimonoRequestError.init(reason: "サーバーの調子がおかしいようです"))
                }
                return
            }

            if response.statusCode >= 400 {
                DispatchQueue.main.async {
                    handler.onError(KarimonoRequestError.init(reason: "不正な操作のようです"))
                }
                return
            }

            do {
                let result = try JSONDecoder().decode([Borrowing].self, from: data)
                DispatchQueue.main.async {
                    handler.onSucess(result)
                }
                return
            } catch {
                DispatchQueue.main.async {
                    handler.onError(KarimonoRequestError.init(reason: "エラー"))
                }
                return
            }
        }

        task.resume()
    }
}
