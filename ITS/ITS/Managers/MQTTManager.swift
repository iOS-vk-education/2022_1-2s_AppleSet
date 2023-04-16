//
//  MQTTManager.swift
//  ITS
//
//  Created by Всеволод on 27.03.2023.
//

import Foundation
import CocoaMQTT


final class MQTTManager {
    
    static let shared = MQTTManager()
    static let receivedNotificationKey: NSNotification.Name = .init(rawValue: "com.AppleSet.ITS.receivedNotificationKey")
    static let subscribedNotificationKey: NSNotification.Name = .init(rawValue: "com.AppleSet.ITS.subscribedNotificationKey")
    static let unsubscribedNotificationKey: NSNotification.Name = .init(rawValue: "com.AppleSet.ITS.unsubscribedNotificationKey")
    
    private let queue = DispatchQueue(label: "MQTT", qos: .utility, attributes: .concurrent)
    
    private static let host = "test.mosquitto.org"
    private static let port = 1883
    
    private var mqtt5: CocoaMQTT5?
    private var state: CocoaMQTTConnState {
        didSet {
            if state == .connected {
                queue.resume()
            } else {
                queue.suspend()
            }
        }
    }
    
    private init() {
        state = .disconnected
    }
    
    func start() {
        
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        let new_mqtt5 = CocoaMQTT5(clientID: clientID, host: "test.mosquitto.org", port: 1883)
        new_mqtt5.delegate = self
        
        state = .connecting
        
        if new_mqtt5.connect() {
            mqtt5 = new_mqtt5
        } else {
            print("[DEBUG] not connected")
            state = .disconnected
        }
    }
    
    func subscribe(to topic: String) {
        if state == .connected {
            mqtt5?.subscribe(topic, qos: .qos1)
        } else {
            queue.async { [weak self] in
                DispatchQueue.main.async {
                    self?.mqtt5?.subscribe(topic, qos: .qos1)
                }
            }
        }
    }
    
    func unsubscribe(from topic: String) {
        if state == .connected {
            mqtt5?.unsubscribe(topic)
        } else {
            queue.async { [weak self] in
                DispatchQueue.main.async {
                    self?.mqtt5?.unsubscribe(topic)
                }
            }
        }
    }
    
    func publish(message: String, to topic: String) {
        if state == .connected {
            mqtt5?.publish(topic, withString: message, qos: .qos1, properties: .init())
        } else {
            queue.async { [weak self] in
                DispatchQueue.main.async {
                    self?.mqtt5?.publish(topic, withString: message, qos: .qos1, properties: .init())
                }
            }
        }
    }
}


extension MQTTManager: CocoaMQTT5Delegate {
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
        state = .connected
        print("[DEBUG] connected")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        print("[DEBUG] message published: \(message.string!) ### in topic: \(message.topic)")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
        
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
        
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?) {
        guard let messageString = message.string else {
            return
        }
        
        print("[DEBUG] message recieved: \(messageString) ### from topic: \(message.topic)")
        NotificationCenter.default.post(name: Self.receivedNotificationKey, object: nil,
                                        userInfo: ["topic" : message.topic,
                                                   "message" : messageString])
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
        success.forEach { topic, state in
            if state as? Int == 1, let topic = topic as? String {
                
                print("[DEBUG] subscribed to topic: \(topic)")
                NotificationCenter.default.post(name: Self.subscribedNotificationKey, object: nil,
                                                userInfo: ["topic" : topic])
            } else {
                print("[DEBUG] can't subscribe to topic: \(topic)")
            }
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], UnsubAckData: MqttDecodeUnsubAck?) {
        topics.forEach { topic in
            
            NotificationCenter.default.post(name: Self.unsubscribedNotificationKey, object: nil,
                                            userInfo: ["topic" : topic])
            print("[DEBUG] unsubscribed from topic: \(topic)")
            
        }
    }
    
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
        
    }
    
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
        
    }
    
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
        
    }
    
    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: Error?) {
        print("[DEBUG] disconnected")
        state = .disconnected
        
        guard let error = err else {
            return
        }
        
        print(error.localizedDescription)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
        
    }
    
}

