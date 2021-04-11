//
//  ContentViewModel.swift
//  MinecraftLogin (iOS)
//
//  Created by 内間理亜奈 on 2021/04/01.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    
    // MARK: - Inputs
    enum Inputs {
        case onCommit(userName: String, passWord: String)
    }
    
    // MARK: - Outputs
    @Published var inputText: String = ""
    @Published var isShowError = false
    @Published var isLoading = false
    
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
        bind()
    }
    
    func apply(inputs: Inputs) {
        switch inputs {
        case .onCommit(let userName, let passWord):
            onCommitSubject.send([userName, passWord])
        }
    }
    
    // MARK: - Private
    private let apiService: APIServiceType
    private let onCommitSubject = PassthroughSubject<[String], Never>()
    private let responseSubject = PassthroughSubject<String, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private var cancellables: [AnyCancellable] = []
    
    
    
    
    private func bind() {
        let responseSubscriber = onCommitSubject
            .flatMap{ [apiService] (query) in
                apiService.request(with: Request1(query: query, code: "CODE", id: query[0], password: query[1]))
                    .catch { [weak self] error -> Empty<String, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }
            .map{ $0 }
            .sink(receiveValue: {[weak self] (message) in
                guard let self = self else { return }
                self.inputText = message
                self.isLoading = false
            })
        
        let loadingStartSubscriber = onCommitSubject
            .map { _ in true }
            .assign(to: \.isLoading, on: self)
        
        let errorSubscriber = errorSubject
            .sink(receiveValue: { [weak self] (error) in
                guard let self = self else { return }
                self.isShowError = true
                self.isLoading = false
            })
        
        cancellables += [
            responseSubscriber,
            loadingStartSubscriber,
            errorSubscriber
        ]
        
    }
}
