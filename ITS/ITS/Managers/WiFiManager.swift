//
//  WiFiManager.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import Foundation
import Network

enum WiFiError: Error {
    case badUrl
    case noData
    case timeout
    case notConnected
    case other(String)
}


protocol WiFiManagerDescription {
    func getRequest(url: String, completion: @escaping (Result<Data, WiFiError>) -> Void)
    func postRequest(url: String, data: Data,  completion: @escaping (Result<Data, WiFiError>) -> Void)
    func start()
}


final class WiFiManager: WiFiManagerDescription {
    static let shared: WiFiManagerDescription = WiFiManager()
    private let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
    private let monitorQueue = DispatchQueue(label: "monitorWifiConnection")
    private var isConnected = false
    
    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isConnected = true
                print("We're connected")
            } else {
                self?.isConnected = false
                print("No connection")
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    func getRequest(url: String, completion: @escaping (Result<Data, WiFiError>) -> Void) {
        guard isConnected else {
            completion(.failure(.notConnected))
            return
        }
        
        guard let url = URL(string: url) else {
            completion(.failure(.badUrl))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 2.0
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                if (error as? URLError)?.code == .timedOut {
                    completion(.failure(.timeout))
                } else {
                    completion(.failure(.other(error.localizedDescription)))
                }
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func postRequest(url: String, data: Data,  completion: @escaping (Result<Data, WiFiError>) -> Void) {
        guard isConnected else {
            completion(.failure(.notConnected))
            return
        }
        
        guard let url = URL(string: url) else {
            completion(.failure(.badUrl))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                if (error as? URLError)?.code == .timedOut {
                    completion(.failure(.timeout))
                } else {
                    completion(.failure(.other(error.localizedDescription)))
                }
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

