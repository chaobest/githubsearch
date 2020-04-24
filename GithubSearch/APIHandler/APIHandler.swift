//
//  APIHandler.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/17/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case nodata
    case domainError(message: String?)
    case decodingError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .domainError(message: let message):
            return message
        case .nodata:
            return "No data"
        case .decodingError:
            return "Cannot parse data"
        }
    }
}

class APIHandler {
    static let shared = APIHandler()
    private init() {}
    typealias ResultCallback<T> = (Result<T, NetworkError>) -> Void
    
    private func fetch(_ urlString: String, completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("token 2480a0e04b3d83686b2dc85e41a6f3a88bc06627", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, respose, error) in
            guard let data = data, let _ = respose else {
                if let _ = error {
                    completionHandler(.failure(NetworkError.domainError(message: error?.localizedDescription)))
                } else {
                    completionHandler(.failure(NetworkError.nodata))
                }
                return
            }
            
            if let httpResponse = respose as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                    completionHandler(.failure(NetworkError.domainError(message: "\(httpResponse.statusCode)")))
                    return
                }
                completionHandler(.success(data))
            }
        }.resume()
    }
    
    func makeLoginCall(_ username: String, _ password: String, completionHandler: @escaping ResultCallback<LoginResponse?>) {
        let stringBuffer = Data((username + ":" + password).utf8)
        let encodeAuth = stringBuffer.base64EncodedString()
        let url = URL(string: baseURL + EndPoint.logIn.rawValue)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Basic " + encodeAuth, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, respose, error) in
            guard let data = data, let _ = respose else {
                if let _ = error {
                    completionHandler(.failure(NetworkError.domainError(message: error?.localizedDescription)))
                } else {
                    completionHandler(.failure(NetworkError.nodata))
                }
                return
            }

            if let httpResponse = respose as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    do {
                        let loginStatus = try JSONDecoder().decode(LoginResponse.self, from: data)
                        completionHandler(.failure(NetworkError.domainError(message: loginStatus.message)))
                    } catch {
                        completionHandler(.failure(NetworkError.decodingError))
                    }
                    return
                } else if httpResponse.statusCode == 200 {
                    completionHandler(.success(nil))
                    return
                }
            }
        }.resume()
    }
    
    func getSearchUsers(_ username: String, page: Int = 0, completionHandler: @escaping ResultCallback<[GitUser]>) {
        let url = baseURL + EndPoint.users.rawValue + username + "&page=\(page)"
        fetch(url) { result in
            switch result {
            case .success(let data):
                do {
                    let users = try JSONDecoder().decode(GitUsers.self, from: data)
                    completionHandler(.success(users.items))
                } catch {
                    completionHandler(.failure(NetworkError.decodingError))
               }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getRepos(_ urlString: String, completionHandler: @escaping ResultCallback<[GitRepo]>) {
        fetch(urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let repos = try JSONDecoder().decode([GitRepo].self, from: data)
                    completionHandler(.success(repos))
                } catch {
                    completionHandler(.failure(NetworkError.decodingError))
               }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getImage(_ urlString: String, completionHandler: @escaping ResultCallback<AnyObject?>) {
        fetch(urlString) { result in
            switch result {
            case .success(let data):
                if let imageToCache = UIImage(data: data) {
                    completionHandler(.success(imageToCache))
                    return
                }
                completionHandler(.success(nil))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getUserDetail(_ urlString: String, completionHandler: @escaping ResultCallback<UserDetail>) {
        fetch(urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let detail = try JSONDecoder().decode(UserDetail.self, from: data)
                    completionHandler(.success(detail))
                } catch {
                    completionHandler(.failure(NetworkError.decodingError))
               }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
