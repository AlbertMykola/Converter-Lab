//
//  NetworkManager.swift
//  Converter Lab
//
//  Created by Albert on 01.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import Foundation

class NetworkService {
    
    static var shared = NetworkService()
    
    func request(urlString: String, completion: @escaping (Result <Model, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    let organizations = try JSONDecoder().decode(Model.self, from: data)
                    completion(.success(organizations))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func save(forKey: String, value: Model? ) {
        if let encodedUserDetails = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encodedUserDetails, forKey: forKey)
        }
    }
    
    func load(forKey: String) -> Model? {
        if let decodeData = UserDefaults.standard.object(forKey: forKey) as? Data {
            if let userDetail = try? JSONDecoder().decode(Model.self, from: decodeData) {
                return userDetail
            }
        }
        return Model()
    }
}
