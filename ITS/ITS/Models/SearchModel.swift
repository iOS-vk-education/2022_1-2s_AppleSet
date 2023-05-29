//
//  SearchModel.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import Foundation


enum SearchError: Error {
    case wifiDisconnected
    case deviceDisconnected
    case somethingWrong
}

struct DeviceSettings: Codable {
    let id: String
    let type: String
}

protocol SearchModelOutput: AnyObject {
    
}

final class SearchModel {
    private weak var output: SearchModelOutput?
    
    init(output: SearchModelOutput) {
        self.output = output
    }
    
    func checkConnectionToDevice(completion: @escaping (Result<DeviceSettings, SearchError>) -> Void) {
        WiFiManager.shared.getRequest(url: "http://192.168.200.1/device/ping") { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let settings = try decoder.decode(DeviceSettings.self, from: data)
                    completion(.success(settings))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.somethingWrong))
                }
            case .failure(let wifiError):
                switch wifiError {
                case .notConnected:
                    completion(.failure(.wifiDisconnected))
                case .timeout:
                    completion(.failure(.deviceDisconnected))
                default:
                    completion(.failure(.somethingWrong))
                }
                
            }
        }
    }
}

