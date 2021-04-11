//
//  APIService.swift
//  MinecraftLogin (iOS)
//
//  Created by 内間理亜奈 on 2021/04/01.
//

import Foundation
import Combine

protocol APIRequestType {
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpBody: RequestBody1? { get }
}

protocol APIServiceType {
    func request<Request>(with request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType
}

final class APIService: APIServiceType {
    private let baseURLString: String
    
    init(baseURLString: String = "https://us-central1-minecraft-auto-login.cloudfunctions.net") {
        self.baseURLString = baseURLString
    }
    
    func request<Request>(with request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request : APIRequestType {
        
        guard let pathURL = URL(string: request.path, relativeTo: URL(string: baseURLString)) else {
            return Fail(error: APIServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        let jsonEncoder = JSONEncoder()
        
        
        if let data = request.httpBody, let jsonData = try? jsonEncoder.encode(data) {
            urlRequest.httpBody = jsonData
        }

        
        
        urlRequest.httpMethod = "POST"
        
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let decorder = JSONDecoder()
        decorder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{ data, URLResponse in
                let data = data as Data
                let httpResponse = URLResponse as? HTTPURLResponse
                print("data: ", data)
                print("statusCode:", httpResponse?.statusCode)
                print("dataの中身: ", String(data: data, encoding: .utf8)!)
                return String(data: data, encoding: .utf8)! as! Request.Response
            }
//            .mapError { _ in APIServiceError.responseError }
//            .decode(type: Request.Response.self, decoder: decorder)
//            .map { data in
//                print("decoded", data)
//                return data
//            }
            .mapError({ (error) -> APIServiceError in
                APIServiceError.parseError(error)
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
