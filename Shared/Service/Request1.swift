//
//  Request1.swift
//  MinecraftLogin (iOS)
//
//  Created by 内間理亜奈 on 2021/04/01.
//

import Foundation

struct Request1: APIRequestType {
    typealias Response = Response1
    
    var path: String { return "/search/repositoryes"}
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "userName", value: query[0]),
            .init(name: "passWord", value: query[1])
        ]
    }
    private let query: [String]
    
    init(query: [String]) {
        self.query = query
    }
}

