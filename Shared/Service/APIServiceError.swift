//
//  APIServiceError.swift
//  MinecraftLogin (iOS)
//
//  Created by 内間理亜奈 on 2021/04/01.
//

import Foundation

enum APIServiceError: Error {
    case invalidURL
    case responseError
    case parseError(Error)
}
