//
//  LampPresenter.swift
//  ITS
//
//  Created by Всеволод on 09.04.2023.
//

import Foundation


enum SendFunction: String {
    case led = "led"
    case brightness = "brightness"
}


protocol SmartLightPresenterOutput: AnyObject {
    func updateState(for function: SendFunction, message: String)
    func setUIEnabled()
    func setUIDisabled()
    func setDisconnected()
}

final class SmartLightPresenter {
    
    private weak var output: SmartLightPresenterOutput?
    private lazy var model = MQTTModel(output: self)
    private var deviceID: String?
    
    private var functionTopics: [SendFunction : String] = [:]
    private var statusFunctions: [String : SendFunction] = [:]
    
    private var mode: Mode = .DISCONNECTED
    
    
    init(output: SmartLightPresenterOutput) {
        self.output = output
    }
    
    func setup(with deviceID: String) {
        self.deviceID = deviceID
        model.setup(with: deviceID)
    }
    
    func didLoadView(with functionTopics: [String : String], statusTopics: [String : String], connectionTopics: [String : String]) {
        output?.setDisconnected()
        
        setFunctionTopics(from: functionTopics)
        setStatusTopics(from: statusTopics)
        
        model.setConnectionTopics(from: connectionTopics)
        model.startConnecting(to: statusFunctions.keys.shuffled())
    }
    
    func send(from sender: SendFunction, message: String) {
        guard let sendTopic = functionTopics[sender] else {
            return
        }
        
        model.send(message: message, to: sendTopic)
    }

    
    private func setFunctionTopics(from functions: [String : String]) {
        functions.forEach { functionString, topic in
            if let function = SendFunction(rawValue: functionString) {
                functionTopics[function] = topic
            } else {
                print("[DEBUG] unknown function: " + functionString + " ### of topic: " + topic)
            }
        }
    }
    
    private func setStatusTopics(from statusTopics: [String : String]) {
        statusTopics.forEach { functionString, statusTopic in
            if let function = SendFunction(rawValue: functionString) {
                statusFunctions[statusTopic] = function
            } else {
                print("[DEBUG] unknown send function: " + functionString + " ### of status topic: " + statusTopic)
            }
            
        }
    }
}

extension SmartLightPresenter: MQTTModelOutput {
    func update(for topic: String, message: String) {
        guard mode == .READY, let statusFunction = statusFunctions[topic] else {
            return
        }
        
        output?.updateState(for: statusFunction, message: message)
    }
    
    func setReady() {
        mode = .READY
        output?.setUIEnabled()
    }
    
    func setChecking() {
        mode = .CHECKING
        output?.setUIDisabled()
    }
    
    func setDisconnected() {
        mode = .DISCONNECTED
        output?.setDisconnected()
    }
}
