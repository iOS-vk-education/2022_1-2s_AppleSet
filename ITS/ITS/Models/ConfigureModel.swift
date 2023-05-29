//
//  ConfigureModel.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import Foundation


enum ConfigureError: Error {
    case deviceDisconnected
    case wifiDisconnected
    case scanNotComplete
    case somethingWrong
}

enum SetupStatus: Int, Codable {
    case connecting = 0
    case noSsidAvailable = 1
    case connected = 3
    case connectFailed = 4
    case wrongPassword = 6
    case disconnected = 7
}


struct Network: Codable {
    let ssid: String
    let isOpen: Bool
}

struct WiFi: Codable {
    let ssid: String
    let password: String
}

struct Response: Codable {
    let status: SetupStatus
}


protocol ConfigureModelOutput: AnyObject {
    
}

final class ConfigureModel {
    private weak var output: ConfigureModelOutput?
    
    init(output: ConfigureModelOutput) {
        self.output = output
    }
    
    func getAvailableNetworks(completion: @escaping (Result<[Network], ConfigureError>) -> Void) {
        WiFiManager.shared.getRequest(url: "http://192.168.200.1/device/scanNetworks") { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let networks = try decoder.decode([Network].self, from: data)
                    completion(.success(networks))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.somethingWrong))
                }
            case .failure(let wifiError):
                switch wifiError {
                case .timeout:
                    completion(.failure(.deviceDisconnected))
                case .notConnected:
                    completion(.failure(.wifiDisconnected))
                case .noData:
                    completion(.failure(.scanNotComplete))
                default:
                    completion(.failure(.somethingWrong))
                }
            }
        }
    }
    
    func setupNetwork(name: String, password: String, completion: @escaping (Result<Response, ConfigureError>) -> Void) {
        let wifi = WiFi(ssid: name, password: password)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(wifi) else {
            return
        }
        
        WiFiManager.shared.postRequest(url: "http://192.168.200.1/device/configureNetwork", data: data) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(Response.self, from: data)
                    completion(.success(response))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.somethingWrong))
                }
            case .failure(let wifiError):
                switch wifiError {
                case .timeout:
                    completion(.failure(.deviceDisconnected))
                case .notConnected:
                    completion(.failure(.wifiDisconnected))
                default:
                    completion(.failure(.somethingWrong))
                }
            }
        }
    }
    
    func getStatusConnect(completion: @escaping (Result<Response, ConfigureError>) -> Void) {
        WiFiManager.shared.getRequest(url: "http://192.168.200.1/device/statusConnect") { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(Response.self, from: data)
                    completion(.success(response))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.somethingWrong))
                }
            case .failure(let wifiError):
                switch wifiError {
                case .timeout:
                    completion(.failure(.deviceDisconnected))
                case .notConnected:
                    completion(.failure(.wifiDisconnected))
                default:
                    completion(.failure(.somethingWrong))
                }
            }
        }
    }
}

