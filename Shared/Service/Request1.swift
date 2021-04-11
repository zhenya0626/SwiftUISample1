//
//  Request1.swift
//  MinecraftLogin (iOS)
//
//  Created by 内間理亜奈 on 2021/04/01.
//

import Foundation

struct Request1: APIRequestType {
    typealias Response = String
    
    var path: String { return "/execute_login"}
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "userName", value: query[0]),
            .init(name: "passWord", value: query[1])
        ]
    }
    
    var httpBody: RequestBody1? {
        let body = RequestBody1(code: code, id: id, password: password)
        return body
    }

    
    private let query: [String]
    private let code: String
    private let id: String
    private let password: String
    
    init(query: [String], code: String, id: String, password: String) {
        self.query = query
        self.code = code
        self.id = id
        self.password = password
    }
}

