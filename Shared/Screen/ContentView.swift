//
//  ContentView.swift
//  Shared
//
//  Created by 内間理亜奈 on 2021/04/01.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel = .init(apiService: APIService())
    
    @AppStorage("userName")
    private var userName = ""
    
    @AppStorage("passWord")
    private var passWord = ""
    
    var body: some View {
        if viewModel.isLoading {
            Text("読み込み中")
        } else {
            TextField("名前を入力", text: $userName)
            .frame(width: UIScreen.main.bounds.width - 40)
            TextField("パスワードを入力", text: $passWord)
            .frame(width: UIScreen.main.bounds.width - 40)
            Button(action: {
                viewModel.apply(inputs: .onCommit(userName: userName, passWord: passWord))
            }) {
                Text("ログイン")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
