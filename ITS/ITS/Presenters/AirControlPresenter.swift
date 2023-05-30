//
//  AirControlPresenter.swift
//  ITS
//
//  Created by Всеволод on 15.05.2023.
//

import Foundation


protocol AirControlPresenterOutput: AnyObject {
    func setConnected()
    func setConnecting()
    func setDisconnected()
    func updateValue(of function: AirController.Function, value: Float)
}


final class AirControlPresenter {
    private weak var output: AirControlPresenterOutput?
    private lazy var model = MQTTModel(output: self)
    private var airController: AirController?
    
    private var functionTopics: [String: AirController.Function] = [:]
    
    init(output: AirControlPresenterOutput) {
        self.output = output
    }
    
    func setup(with decviceName: String) {
        guard let airController = DevicesManager.shared.getAirControllerStatus(name: decviceName) else {
            return
        }
        
        self.airController = airController
        model.setup(with: airController.deviceID)
        
        setFunctionTopics()
    }
    
    func didLoadView() {
        guard let airController else {
            return
        }
        
        if airController.state == .disconnected {
            output?.setConnecting()
            model.startConnecting(to: functionTopics.keys.shuffled())
        } else {
            output?.setConnected()
        }
    }
    
    private func setFunctionTopics() {
        guard let airController else {
            return
        }
        
        AirController.Function.allCases.forEach { function in
            let topic = airController.deviceID + "/\(function.rawValue)"
            functionTopics[topic] = function
        }
    }
    
    func getValueOfFunction(function: AirController.Function) -> Float {
        guard let airController else {
            return 0
        }
        
        switch function {
        case .temperature:
            guard let temperature = airController.temperature else {
                return 0
            }
            return temperature
            
        case .humidity:
            guard let humidity = airController.humidity else {
                return 0
            }
            return humidity
            
        case .pressure:
            guard let pressure = airController.pressure else {
                return 0
            }
            return pressure
            
        case .height:
            guard let height = airController.height else {
                return 0
            }
            return height
        }
    }
}

extension AirControlPresenter: MQTTModelOutput {
    func update(for topic: String, message: String) {
        guard
            let function = functionTopics[topic],
            let value = Float(message)
        else {
            return
        }
        
        output?.updateValue(of: function, value: value)
    }
    
    func updateStatus(with status: String) {
        output?.setConnected()
        
        let ACStatus = status.split(separator: "#").map{ String($0) }
        guard
            let temperature = Float(ACStatus[0]),
            let humidity = Float(ACStatus[1]),
            let pressure = Float(ACStatus[2]),
            let height = Float(ACStatus[3])
        else {
            return
        }
        
        airController?.temperature = temperature
        airController?.humidity = humidity
        airController?.pressure = pressure
        airController?.height = height
        airController?.state = .connected
        
        guard let airController else {
            return
        }
        DevicesManager.shared.updateAirControllerStatus(status: airController)
    }
    
    func setReady() {
        model.getStatus()
    }
    
    func setDisconnected() {
        print(#function)
    }
    
    
}
