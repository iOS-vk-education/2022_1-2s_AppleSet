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
    case connection
}

enum ConnectionTopicType: String {
    case ping = "ping"
    case pong = "pong"
}

enum ReceiveFunction: String {
    case temperature = "temperature"
}

enum SendFunction: String {
    case led = "led"
    case brightness = "brightness"
}

protocol MqttTestPresenterOutput: AnyObject {
    func update(for function: ReceiveFunction, message: String)
    func updateState(for function: SendFunction, message: String)
}

final class MqttTestPresenter {
    
    private weak var output: MqttTestPresenterOutput?
    private lazy var model = MqttTestModel(output: self)
    
    private var receiveFunctions: [String : ReceiveFunction] = [:]
    private var statusFunctions: [String : SendFunction] = [:]
    
    private var sendTopics: [SendFunction : String] = [:]
    
    private var receiveTopicType: [String : ReceiveTopicType] = [:]
    
    private var activeTopics: Set<String> = Set<String>() {
        didSet {
            if activeTopics.count == receiveFunctions.count + statusFunctions.count + 1 {
                model.startNotify()
            }
        }
    }
    
    
    init(output: MqttTestPresenterOutput) {
        self.output = output
    }
    
    func didLoadView(with functions: [String : String], statusTopics: [String : String], connectionTopics: [String : String]) {
        model.start()
        
        setTopics(from: functions)
        setStatusTopics(from: statusTopics)
        setConnectionTopics(from: connectionTopics)
        
        model.startPing()
    }

    
    private func setTopics(from functions: [String : String]) { // funcStr : topic
        functions.forEach { functionString, topic in
            if let function = ReceiveFunction(rawValue: functionString) {
                receiveTopicType[topic] = .recieve
                receiveFunctions[topic] = function
            } else if let function = SendFunction(rawValue: functionString) {
                sendTopics[function] = topic
            } else {
                print("[DEBUG] unknown function")
            }
        }
    }
    
    private func setStatusTopics(from statusTopics: [String : String]) {
        statusTopics.forEach { functionString, statusTopic in
            if let function = SendFunction(rawValue: functionString) {
                receiveTopicType[statusTopic] = .status
                statusFunctions[statusTopic] = function
            } else {
                print("[DEBUG] unknown send function of status topic")
            }
            
        }
    }
    
    private func setConnectionTopics(from connectionTopics: [String : String]) {
        var connTopics: [ConnectionTopicType : String] = [:]
        connectionTopics.forEach { typeString, connectionTopic in
            if let type = ConnectionTopicType(rawValue: typeString) {
                if type == .pong {
                    receiveTopicType[connectionTopic] = .connection
                }
                
                connTopics[type] = connectionTopic
            } else {
                print("[DEBUG] unknown connection type of connection topic")
            }
        }
        
        model.setup(with: connTopics)
    }
    
    
    
    func sendMessage(from sender: SendFunction, message: String) {
        model.send(message: message, to: sendTopics[sender]!)
    }
}

extension MqttTestPresenter: MqttTestModelOutput {
    func update(for topic: String, message: String) {
        switch receiveTopicType[topic] {
        case .recieve:
            output?.update(for: receiveFunctions[topic]!, message: message)
        case .status:
            output?.updateState(for: statusFunctions[topic]!, message: message)
        case .connection:
            if message == "pong" {
                model.stopPing()
                model.startRecieving(from: receiveFunctions, and: statusFunctions)
            } else if message == "ready" {
                model.stopNotify()
                model.stopConnecting()
            }
        case .none:
            return
        }
    }
    
    func didSubscribedTo(topic: String) {
        activeTopics.insert(topic)
    }
    
    func didUnsubscribedFrom(topic: String) {
        activeTopics.remove(topic)
    }
}



