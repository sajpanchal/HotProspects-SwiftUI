//
//  ContentView.swift
//  HotProspects
//
//  Created by saj panchal on 2021-08-22.
//

import SwiftUI

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

struct ContentView: View {
    @State var backgroundColor = Color.red
    /*@ObservedObject var updater = DelayedUpdater()
    @ObservedObject var user = User()
    @State var selectedTab = 0*/
   
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
                .background(backgroundColor)
            Text("Change Color")
                .padding()
                .contextMenu {
                    Button(action: {
                        self.backgroundColor = .red
                    }, label: {
                        Text("Red")
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.red)
                    })
                    Button(action: {
                        self.backgroundColor = .green
                    }, label: {
                        Text("Green")
                    })
                    Button(action: {
                        self.backgroundColor = .blue
                    }, label: {
                        Text("Blue")
                    })
                }
                   
                
        }
        
        //Text("Value is: \(updater.value)")
        /*Text("Hello World")
        .onAppear {
            self.fetchData(from: "https://www.apple.com") {
                result in
                switch result {
                    case .success(let str): print("hello:",str)
                    case .failure(let error):
                        switch error {
                            case .badURL: print("Bad URL")
                            case .requestFailed: print("Network problems")
                            case .unknown: print("Unkonw error")
                        }
                    }
                }
        }*/
    }
    
    func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        // success or failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    // convert data to string
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
