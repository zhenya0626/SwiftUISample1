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
    private let responseSubject = PassthroughSubject<Response1, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private var cancellables: [AnyCancellable] = []
    
    
    
    
    private func bind() {
        let responseSubscriber = onCommitSubject
            .flatMap{ [apiService] (query) in
                apiService.request(with: Request1(query: query))
                    .catch { [weak self] error -> Empty<Response1, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }
            .map{ $0.items }
            .sink(receiveValue: {[weak self] (repositories) in
                guard let self = self else { return }
                self.inputText = ""
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
