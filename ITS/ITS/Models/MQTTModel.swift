//
//  MQTTModel.swift
//  ITS
//
//  Created by Всеволод on 09.04.2023.
//

import Foundation


protocol MQTTModelOutput: AnyObject {
    func update(for topic: String, message: String)
    func setReady()
    func setChecking()
    func setDisconnected()
}


final class MQTTModel {
    private var messages: [String : String] = [:]
    
    private var connectionTopics: [ConnectionTopicType : String] = [:]
    
    private weak var output: MQTTModelOutput?
    private var deviceID: String?
    
    private var needTopics: [String] = []
    private var activeTopics: Set<String> = Set<String>() {
        didSet {
            if activeTopics.isSuperset(of: needTopics) {
                 startNotify()
            }
        }
    }
    
    private var pingTimer: Timer?
    
    init(output: MQTTModelOutput) {
        self.output = output
    }
    
    func setup(with deviceID: String) {
        self.deviceID = deviceID
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceived(_:)),
                                               name: MQTTManager.receivedNotificationKey,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSubscribed(_:)),
                                               name: MQTTManager.subscribedNotificationKey,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSubscribed(_:)),
                                               name: MQTTManager.unsubscribedNotificationKey,
                                               object: nil)
    }
    
    func setConnectionTopics(from topics: [String : String]) {
        var connTopics: [ConnectionTopicType : String] = [:]
        topics.forEach { typeString, connectionTopic in
            if let type = ConnectionTopicType(rawValue: typeString) {
                connTopics[type] = connectionTopic
            } else {
                print("[DEBUG] unknown connection type: " + typeString + " ### of topic: " + connectionTopic)
            }
        }
        
        connectionTopics = connTopics
    }
    
    func send(message: String, to topic: String) {
        MQTTManager.shared.publish(message: message, to: topic)
    }
    
    
    func startConnecting(to topics: [String]) {
        needTopics = topics
    
        guard let pongTopic = connectionTopics[.pong] else {
            return
        }
        
        MQTTManager.shared.subscribe(to: pongTopic)
    }
    
    private func startPing() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in
            guard let pingTopic = self?.connectionTopics[.ping] else {
                return
            }
            
            MQTTManager.shared.publish(message: "ping", to: pingTopic)
        }
    }
    
    private func startSubscribing() {
        needTopics.forEach { topic in
            MQTTManager.shared.subscribe(to: topic)
        }
    }
    
    private func startNotify() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let pingTopic = self?.connectionTopics[.ping] else {
                return
            }
            
            MQTTManager.shared.publish(message: "ready", to: pingTopic)
        }
    }
    
    private func stopTimer() {
        pingTimer?.invalidate()
    }
    
}


private extension MQTTModel {
    @objc func didReceived(_ notification: NSNotification) { // in topic: String, message: String
        guard
            let deviceID,
            let topic = notification.userInfo?["topic"] as? String,
            topic.split(separator: "/")[0] == deviceID,
            let message = notification.userInfo?["message"] as? String
        else {
            return
        }
        
        messages[topic] = message
        if let pongTopic = connectionTopics[.pong], topic == pongTopic {
            if message == "pong" {
                stopTimer()
                startSubscribing()
            } else if message == "ready" {
                stopTimer()
                output?.setReady()
            } else {
                print("[DEBUG] Unexpected message: " + message + " ### in topic: " + pongTopic)
            }
        } else {
            output?.update(for: topic, message: message)
        }
    }
    
    @objc func didSubscribed(_ notification: NSNotification) { // to topic: String
        guard
            let deviceID,
            let topic = notification.userInfo?["topic"] as? String,
            topic.split(separator: "/")[0] == deviceID
        else {
            return
        }
        
        if let pongTopic = connectionTopics[.pong], topic == pongTopic {
            startPing()
        } else {
            activeTopics.insert(topic)
        }
    }
    
    @objc func didUnsubscribed(_ notification: NSNotification) { // from topic: String
        guard
            let deviceID,
            let topic = notification.userInfo?["topic"] as? String,
            topic.split(separator: "/")[0] == deviceID
        else {
            return
        }
        
        activeTopics.remove(topic)
    }
}
