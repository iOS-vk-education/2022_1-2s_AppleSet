//
//  Model.swift
//  MqttTest
//
//  Created by Всеволод on 24.03.2023.
//

import Foundation


protocol ModelOutput: AnyObject {
    func update(for topic: String, message: String)
    func didSubscribedTo(topic: String)
    func didUnsubscribedFrom(topic: String)
}


final class Model {
    private var messages: [String : String] = [:]
    
    private var connectionTopics: [ConnectionTopicType : String] = [:]
    
    private weak var output: ModelOutput?
    
    private lazy var mqttManager = MQttManager(output: self)
    
    private var pingTimer: Timer?
    
    init(output: ModelOutput) {
        self.output = output
    }
    
    func setup(with connectionTopics : [ConnectionTopicType : String]) {
        self.connectionTopics = connectionTopics
    }
    
    func start() {
        mqttManager.start()
    }
    
    func subscribe(to topic: String) {
        mqttManager.subscribe(to: topic)
    }
    
    func send(message: String, to topic: String) {
        mqttManager.publish(message: message, to: topic)
    }
    
    func startRecieving(from receiveFunctions: [String : ReceiveFunction], and statusFunctions: [String : SendFunction]) {
        
        receiveFunctions.forEach { topic, _ in
            mqttManager.subscribe(to: topic)
        }
        
        statusFunctions.forEach { topic, _ in
            mqttManager.subscribe(to: topic)
        }
    }
    
    func getStatus(of functions: [String : SendFunction]) {
        functions.forEach { topic, _ in
            mqttManager.subscribe(to: topic)
        }
    }
    
    
    
    func startPing() {
        guard let pongTopic = connectionTopics[ConnectionTopicType.pong] else {
            return
        }
        mqttManager.subscribe(to: pongTopic)
        
        pingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) {[weak self] _ in
            guard let pingTopic = self?.connectionTopics[ConnectionTopicType.ping] else {
                return
            }
            self?.mqttManager.publish(message: "ping", to: pingTopic)
        }
    }
    
    func stopPing() {
        pingTimer?.invalidate()
    }
    
    func startNotify() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let pingTopic = self?.connectionTopics[ConnectionTopicType.ping] else {
                return
            }
            self?.mqttManager.publish(message: "ready", to: pingTopic)
        }
    }
    
    func stopNotify() {
        pingTimer?.invalidate()
    }
    
    func stopConnecting() {
        pingTimer?.invalidate()
        mqttManager.unsubscribe(from: connectionTopics[ConnectionTopicType.pong]!)
    }
}


extension Model: MqttManagerOutput {
    func update(for topic: String, message: String) {
        messages[topic] = message
        output?.update(for: topic, message: message)
    }
    
    func didSubscribed(to topic: String) {
        output?.didSubscribedTo(topic: topic)
    }
    
    func didUnsubscribed(from topic: String) {
        output?.didUnsubscribedFrom(topic: topic)
    }
}

