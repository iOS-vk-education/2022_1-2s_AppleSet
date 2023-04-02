//
//  MqttTestPresenter.swift
//  ITS
//
//  Created by Всеволод on 27.03.2023.
//

import Foundation

enum ReceiveTopicType {
    case recieve
    case status
}

enum ReceiveFunction: String {
    case temperature = "temperature"
}

enum SendFunction: String {
    case led = "led"
    case brightness = "brightness"
}

enum Mode {
    case READY
    case CHECKING
    case DISCONNECTED
}

protocol MqttTestPresenterOutput: AnyObject {
    func update(for function: ReceiveFunction, message: String)
    func updateState(for function: SendFunction, message: String)
    func setUIEnabled()
    func setUIDisabled()
    func setDisconnected()
}

final class MqttTestPresenter {
    
    private weak var output: MqttTestPresenterOutput?
    private lazy var model = MqttTestModel(output: self)
    
    private var receiveFunctions: [String : ReceiveFunction] = [:]
    private var statusFunctions: [String : SendFunction] = [:]
    
    private var sendTopics: [SendFunction : String] = [:]
    
    private var receiveTopicType: [String : ReceiveTopicType] = [:]
    
    private var mode: Mode = .DISCONNECTED
    
    
    init(output: MqttTestPresenterOutput) {
        self.output = output
    }
    
    func didLoadView(with functions: [String : String], statusTopics: [String : String], connectionTopics: [String : String], connectionTokens: [String : String]) {
        output?.setDisconnected()
        
        model.start()
        
        setTopics(from: functions)
        setStatusTopics(from: statusTopics)
        
        model.setConnectionTopics(from: connectionTopics)
        model.setConnectionTokens(from: connectionTokens)
        
        model.startConnecting(to: receiveFunctions.keys.shuffled() + statusFunctions.keys.shuffled())
    }
    
    func sendMessage(from sender: SendFunction, message: String) {
        guard let sendTopic = sendTopics[sender] else {
            return
        }
        
        model.send(message: message, to: sendTopic)
    }

    
    private func setTopics(from functions: [String : String]) { // funcStr : topic
        functions.forEach { functionString, topic in
            if let function = ReceiveFunction(rawValue: functionString) {
                receiveTopicType[topic] = .recieve
                receiveFunctions[topic] = function
            } else if let function = SendFunction(rawValue: functionString) {
                sendTopics[function] = topic
            } else {
                print("[DEBUG] unknown function: " + functionString + " ### of topic: " + topic)
            }
        }
    }
    
    private func setStatusTopics(from statusTopics: [String : String]) {
        statusTopics.forEach { functionString, statusTopic in
            if let function = SendFunction(rawValue: functionString) {
                receiveTopicType[statusTopic] = .status
                statusFunctions[statusTopic] = function
            } else {
                print("[DEBUG] unknown send function: " + functionString + " ### of status topic: " + statusTopic)
            }
            
        }
    }
}

extension MqttTestPresenter: MqttTestModelOutput {
    func update(for topic: String, message: String) {
        guard mode == .READY else {
            return
        }
        
        switch receiveTopicType[topic] {
        case .recieve:
            output?.update(for: receiveFunctions[topic]!, message: message)
        case .status:
            output?.updateState(for: statusFunctions[topic]!, message: message)
        case .none:
            return
        }
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



