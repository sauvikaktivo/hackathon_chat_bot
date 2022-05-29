//
//  ChatBotAPI.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import Foundation
import Combine
import UIKit

struct ChatBotRequest {
    enum RequestType: String {
        case dayFirstLaunch
        case typedText
        case quickAction
    }
    let type: RequestType
    let version: String = "1.0.0"
    let data: [String : AnyObject]?
}
extension ChatBotRequest {
    var requestBody: Data {
        var dict: [String: AnyObject] = [
            "code": type.rawValue as AnyObject,
            "version": version as AnyObject
        ]
        if let data = data { dict["data"] = data as AnyObject }
        let finalPayload = ["request": dict as AnyObject]
        return try! JSONSerialization.data(withJSONObject: finalPayload, options: .prettyPrinted)
    }
}

struct ChatBotServerEndPoint {
    let request: ChatBotRequest
    let path: String
    let method: String
    
    var networkRequest: URLRequest {
        var req = URLRequest(url: URL(string: baseUrl)!.appendingPathComponent(path))
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = request.requestBody
        req.httpMethod = method
        return req
    }
}
// MARK: END POINTS
let baseUrl = "http://localhost:3000"
extension ChatBotServerEndPoint {
    static func userInputText(text: String) -> Self {
        let request = ChatBotRequest(type: .typedText, data: nil)
        return ChatBotServerEndPoint(request: request, path: "/api/v1/chatbot", method: "POST")
    }
    static func dayFirstLaunch() -> Self {
        let request = ChatBotRequest(type: .dayFirstLaunch, data: nil)
        return ChatBotServerEndPoint(request: request, path: "/api/v1/chatbot", method: "POST")
    }
    static func quickAction(taskId: Int) -> Self {
        let request = ChatBotRequest(type: .quickAction, data: ["botTaskId": taskId as AnyObject])
        return ChatBotServerEndPoint(request: request, path: "/api/v1/chatbot", method: "POST")
    }
}

struct API<T: Decodable> {
    static func load(endPoint: ChatBotServerEndPoint,
                                   _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: endPoint.networkRequest)
            .tryMap { result -> T in
                do {
                    let object = try decoder.decode(T.self, from: result.data)
                    return object
                } catch {
                    throw error
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
