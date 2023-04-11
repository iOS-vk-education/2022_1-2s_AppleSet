////
////  MqttTestModel.swift
////  ITS
////
////  Created by Всеволод on 27.03.2023.
////
//
//import Foundation
//
//
//enum ConnectionTokenType: String {
//    case ping = "ping"
//    case pong = "pong"
//    case readyApp = "ready_app"
//    case readyDevice = "ready_device"
//}
//
//
//protocol MqttTestModelOutput: AnyObject {
//    func update(for topic: String, message: String)
//    func setReady()
//    func setChecking()
//    func setDisconnected()
//}
//
//
//final class MqttTestModel {
//    private var messages: [String : String] = [:]
//
//    private var connectionTopics: [ConnectionTopicType : String] = [:]
//    private var connectionTokens: [ConnectionTokenType : String] = [:]
//
//    private weak var output: MqttTestModelOutput?
//
//    private var needTopics: [String] = []
//    private var activeTopics: Set<String> = Set<String>() {
//        didSet {
//            if activeTopics.isSuperset(of: needTopics) {
//                 startNotify()
//            }
//        }
//    }
//
//    private lazy var mqttManager = MQTTManager(output: self)
//
//    private var pingTimer: Timer?
//
//    init(output: MqttTestModelOutput) {
//        self.output = output
//    }
//
//    func start() {
//        mqttManager.start()
//    }
//
//    func setConnectionTopics(from topics: [String : String]) {
//        var connTopics: [ConnectionTopicType : String] = [:]
//        topics.forEach { typeString, connectionTopic in
//            if let type = ConnectionTopicType(rawValue: typeString) {
//                connTopics[type] = connectionTopic
//            } else {
//                print("[DEBUG] unknown connection type: " + typeString + " ### of topic: " + connectionTopic)
//            }
//        }
//
//        connectionTopics = connTopics
//    }
//
//    func setConnectionTokens(from tokens: [String : String]) {
//        var connTokens: [ConnectionTokenType : String] = [:]
//        tokens.forEach { typeString, connectionToken in
//            if let type = ConnectionTokenType(rawValue: typeString) {
//                connTokens[type] = connectionToken
//            } else {
//                print("[DEBUG] unknown connection type: " + typeString + " ### of token: " + connectionToken)
//            }
//        }
//
//        connectionTokens = connTokens
//    }
//
//    func send(message: String, to topic: String) {
//        mqttManager.publish(message: message, to: topic)
//    }
//
//
//    func startConnecting(to topics: [String]) {
//        needTopics = topics
//
//        guard let pongTopic = connectionTopics[.pong] else {
//            return
//        }
//        mqttManager.subscribe(to: pongTopic)
//    }
//
//    private func startPing() {
//        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in
//            guard
//                let pingTopic = self?.connectionTopics[.ping],
//                let pingToken = self?.connectionTokens[.ping]
//            else {
//                return
//            }
//            self?.mqttManager.publish(message: pingToken, to: pingTopic)
//        }
//    }
//
//    private func startSubscribing() {
//        needTopics.forEach { topic in
//            mqttManager.subscribe(to: topic)
//        }
//    }
//
//    private func startNotify() {
//        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            guard
//                let pingTopic = self?.connectionTopics[.ping],
//                let readyAppToken = self?.connectionTokens[.readyApp]
//            else {
//                return
//            }
//
//            self?.mqttManager.publish(message: readyAppToken, to: pingTopic)
//        }
//    }
//
//    private func stopTimer() {
//        pingTimer?.invalidate()
//    }
//
//}
//
//
//extension MqttTestModel: MqttManagerOutput {
//    func didReceived(in topic: String, message: String) {
//        messages[topic] = message
//        if let pongTopic = connectionTopics[.pong], topic == pongTopic {
//            if let pongToken = connectionTokens[.pong], message == pongToken {
//                stopTimer()
//                startSubscribing()
//            } else if let readyDeviceToken = connectionTokens[.readyDevice], message == readyDeviceToken {
//                stopTimer()
//                output?.setReady()
//            } else {
//                print("[DEBUG] Unexpected message: " + message + " ### in topic: " + pongTopic)
//            }
//        } else {
//            output?.update(for: topic, message: message)
//        }
//    }
//
//    func didSubscribed(to topic: String) {
//        if let pongTopic = connectionTopics[.pong], topic == pongTopic {
//            startPing()
//        } else {
//            activeTopics.insert(topic)
//        }
//    }
//
//    func didUnsubscribed(from topic: String) {
//        activeTopics.remove(topic)
//    }
//}
//
//
