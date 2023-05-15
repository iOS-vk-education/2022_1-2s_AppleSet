//
//  MQTTModel.swift
//  ITS
//
//  Created by Всеволод on 09.04.2023.
//

import Foundation


enum ConnectionTopicType: String, CaseIterable {
    case ping = "ping"
    case pong = "pong"
}


protocol MQTTModelOutput: AnyObject {
    func update(for topic: String, message: String)
    func updateStatus(with status: String)
    func setReady()
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
        
        setConnectionTopics()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceived(_:)),
                                               name: MQTTManager.receivedNotificationKey,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSubscribed(_:)),
                                               name: MQTTManager.subscribedNotificationKey,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUnsubscribed(_:)),
                                               name: MQTTManager.unsubscribedNotificationKey,
                                               object: nil)
    }
    
    func setConnectionTopics() {
        guard let deviceID else {
            return
        }
        
        ConnectionTopicType.allCases.forEach { topic in
            connectionTopics[topic] = deviceID + "/\(topic.rawValue)"
        }
    }
    
    func send(message: String, to topic: String) {
        MQTTManager.shared.publish(message: message, to: topic)
    }
    
    
    func startConnecting(to topics: [String]?) {
        if let topics {
            needTopics = topics
        }
    
        guard let pongTopic = connectionTopics[.pong] else {
            return
        }
        
        MQTTManager.shared.subscribe(to: pongTopic)
    }
    
    func getStatus() {
        guard let pingTopic = self.connectionTopics[.ping] else {
            return
        }
        
        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            MQTTManager.shared.publish(message: "status", to: pingTopic)
        })
        pingTimer?.fire()
    }
    
    private func startPing() {
        guard let pingTopic = connectionTopics[.ping] else {
            return
        }
        
        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            MQTTManager.shared.publish(message: "ping", to: pingTopic)
        }
        pingTimer?.fire()
    }
    
    private func startSubscribing() {
        if needTopics.count == 0 {
            startNotify()
        } else {
            needTopics.forEach { topic in
                MQTTManager.shared.subscribe(to: topic)
            }
        }
    }
    
    private func startNotify() {
        guard let pingTopic = connectionTopics[.ping] else {
            return
        }
        
        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            MQTTManager.shared.publish(message: "ready", to: pingTopic)
        }
        pingTimer?.fire()
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
            stopTimer()
            if message == "pong" {
                startSubscribing()
            } else if message == "ready" {
                output?.setReady()
            } else {
                output?.updateStatus(with: message)
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
