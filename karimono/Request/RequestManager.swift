//
//  RequestHandler.swift
//  karimono
//
//  Created by Kei Kameda on 2018/11/17.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import Foundation
import RxSwift

enum RequestMethod {
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

struct KarimonoRequestError: Codable {
    let reason: String
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

    var method: RequestMethod {get}
    var host: String { get }
    var contentType: String { get }
    var accept: String { get }
    var payload: Body { get }
    var path: String { get }
}

enum RequestState<T> {
    case loading
    case complete(T)
    case error(KarimonoRequestError)

    var generalState: RequestStateWithoutType {
        switch self {
        case .loading:
            return .loading
        case .complete:
            return .complete
        case .error(let e):
            return .error(e)
        }
    }

    var observeComplete: Observable<T> {
        switch self {
        case .complete(let r):
            return .just(r)
        case .error:
            return .empty()
        case .loading:
            return .empty()
        }
    }
}

enum RequestStateWithoutType {
    case loading
    case complete
    case error(KarimonoRequestError)

    var isLoading: Bool {
        switch self {
        case .complete:
            return false
        case .error:
            return false
        case .loading:
            return true
        }
    }

    var observeError: Observable<KarimonoRequestError> {
        switch self {
        case .complete:
            return .empty()
        case .error(let e):
            return .just(e)
        case .loading:
            return .empty()
        }
    }
}

protocol RequestExecutable {
    func execRequest<T: RequestDescriable>(handler: T, addtionalHeader: [String: String]) -> Observable<RequestState<T.Response>>
}

class RequestExecuter: RequestExecutable {
    func execRequest<T: RequestDescriable>(handler: T, addtionalHeader: [String: String]) -> Observable<RequestState<T.Response>> {
        let result = try! JSONEncoder().encode(handler.payload)

        var request = URLRequest(url: URL(string: "\(handler.host)/\(handler.path)")!)

        request.setValue(handler.contentType, forHTTPHeaderField: "Content-type")
        request.setValue(handler.accept, forHTTPHeaderField: "Accept")

        for header in addtionalHeader {
             request.setValue(header.value, forHTTPHeaderField: header.key)
        }

        request.httpMethod = handler.method.toString
        request.timeoutInterval = 5
        if handler.method != RequestMethod.get && T.Body.self != Empty.self {
            request.httpBody = result
        }

        let observable = Observable<RequestState<T.Response>>.create { observabe in
            print("request to \(request.url?.absoluteString ?? "-")")
            observabe.onNext(.loading)
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                
                if let err = err {
                    print(err.localizedDescription)
                    if let err = err as? URLError {
                        if err.code == URLError.timedOut {
                            observabe.onNext(.error(KarimonoRequestError.init(reason: "接続状況が悪いです")))
                            observabe.onCompleted()
                            return
                        }

                        if err.code == URLError.notConnectedToInternet {
                            observabe.onNext(.error(KarimonoRequestError.init(reason: "インターネットがオフラインのようです")))
                            observabe.onCompleted()
                            return
                        }
                        observabe.onNext(.error(KarimonoRequestError.init(reason: "通信エラー: \(err.code.rawValue)")))
                        observabe.onCompleted()
                        return

                    }
                    observabe.onNext(.error(KarimonoRequestError.init(reason: "通信エラー")))
                    observabe.onCompleted()
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse else {
                    observabe.onNext(.error(KarimonoRequestError.init(reason: "通信エラー")))
                    observabe.onCompleted()
                    return
                }

                if response.statusCode >= 500 {
                    observabe.onNext(.error(KarimonoRequestError.init(reason: "サーバーの調子がおかしいようです")))
                    observabe.onCompleted()
                    return
                }

                if response.statusCode >= 400 {
                    observabe.onNext(.error(KarimonoRequestError.init(reason: "不正な操作のようです")))
                    observabe.onCompleted()
                    return
                }

                do {
                    let result = try JSONDecoder().decode(T.Response.self, from: data)
                    observabe.onNext(.complete(result))
                    print("request compelete to \(request.url?.absoluteString ?? "-")")
                    observabe.onCompleted()
                    return
                } catch {
                    let str: String? = String(data: data, encoding: .utf8)
                    print(str ?? "")
                    observabe.onNext(.error(KarimonoRequestError.init(reason: "エラー")))
                    observabe.onCompleted()
                    return
                }
            }

            task.resume()

            let disposalbe = Disposables.create {
                task.cancel()
            }
            return disposalbe
        }
        return observable
    }
}

