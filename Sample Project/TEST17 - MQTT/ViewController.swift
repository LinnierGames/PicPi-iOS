//
//  ViewController.swift
//  TEST17 - MQTT
//
//  Created by Erick Sanchez on 11/29/20.
//  Copyright © 2020 Linnier__Games. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var labelConnectionStatus: UILabel!
  @IBOutlet weak var viewConnectionStatus: UIView!
  @IBOutlet weak var textFieldIPAddress: UITextField!
  @IBOutlet weak var textFieldTopicSubscription: UITextField!
  @IBOutlet weak var textFieldMessage: UITextField!
  @IBOutlet weak var buttonConnect: UIButton!
  @IBOutlet weak var buttonSend: UIButton!
  @IBOutlet weak var textViewReceivedMessages: UITextView!

  var mqttManager: MQTTManager?

  @IBAction func pressConnect(_ sender: Any) {
    guard
      let ipAddress = textFieldIPAddress.text, ipAddress.isEmpty != true,
      let topic = textFieldTopicSubscription.text, topic.isEmpty != true
    else {
        return
    }

    mqttManager = MQTTManager(identifier: "idk", host: ipAddress, topic: topic)
    mqttManager?.connect()
    mqttManager?.delegate = self
  }

  @IBAction func pressSend(_ sender: Any) {
    guard let message = textFieldMessage.text, message.isEmpty != true else { return }
    mqttManager?.publish(with: message)

    guard let imageData = #imageLiteral(resourceName: "screenshot").pngData() else { return }
    mqttManager?.publish(data: imageData)
  }
}

extension ViewController: MQTTManagerDelegate {
  func manager(_ manager: MQTTManager, didUpdateConnectionStatus isConnected: Bool) {
    textFieldIPAddress.isEnabled = !isConnected
    textFieldTopicSubscription.isEnabled = !isConnected
    textFieldMessage.isEnabled = isConnected
    buttonConnect.isEnabled = !isConnected
    buttonSend.isEnabled = isConnected

    if isConnected {
      labelConnectionStatus.text = "Connected"
      viewConnectionStatus.backgroundColor = .green
    } else {
      labelConnectionStatus.text = "Disconnected"
      viewConnectionStatus.backgroundColor = .orange
    }
  }

  func manager(_ manager: MQTTManager, didReceive message: String) {
    if let text = textViewReceivedMessages.text{
        let newText = """
        \(text)
        \(message)
        """
        textViewReceivedMessages.text = newText
    } else {
        let newText = """
        \(message)
        """
        textViewReceivedMessages.text = newText
    }

    let myRange = NSMakeRange(textViewReceivedMessages.text.count-1, 0);
    textViewReceivedMessages.scrollRangeToVisible(myRange)
  }
}

import CocoaMQTT

protocol MQTTManagerDelegate: AnyObject {
  func manager(_ manager: MQTTManager, didUpdateConnectionStatus isConnected: Bool)
  func manager(_ manager: MQTTManager, didReceive message: String)
}

class MQTTManager {
  private let mqtt: CocoaMQTT
  private let identifier: String
  private let host: String
  private let topic: String

  weak var delegate: MQTTManagerDelegate?

  init(
    identifier: String,
    host: String,
    topic: String
  ) {
    let clientID = "CocoaMQTT-\(identifier)-" + String(ProcessInfo().processIdentifier)
    self.mqtt = CocoaMQTT(clientID: clientID, host: host, port: 1883)
    self.identifier = identifier
    self.host = host
    self.topic = topic

    self.mqtt.username = ""
    self.mqtt.password = ""
    self.mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
    self.mqtt.keepAlive = 60
    self.mqtt.delegate = self
  }

  func connect() {
    _ = mqtt.connect()
  }

  func subscribe() {
    mqtt.subscribe(topic, qos: .qos1)
  }

  func publish(with message:String) {
    mqtt.publish(topic, withString: message, qos: .qos1)
  }

  func publish(data: Data) {
    let payload = Array<UInt8>(data)
    mqtt.publish(CocoaMQTTMessage(topic: topic, payload: payload))
  }
}

extension MQTTManager: CocoaMQTTDelegate {
  func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck){
    TRACE("ack: \(ack)")

    if ack == .accept {
      delegate?.manager(self, didUpdateConnectionStatus: true)
      mqtt.subscribe(topic, qos: .qos1)
    }
  }
  func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16){
    TRACE("message: \(message.string.description), id: \(id)")
  }
  func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16){
    TRACE("id: \(id)")
  }
  func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ){
    TRACE("message: \(message.string.description), id: \(id)")

    delegate?.manager(self, didReceive: message.string.description)
  }
// This was deprecated
//  func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String){
//  }
  func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
    TRACE("topic: \(topics)")
  }
  func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String){
    TRACE("topic: \(topic)")
  }
  func mqttDidPing(_ mqtt: CocoaMQTT){
    TRACE()
  }
  func mqttDidReceivePong(_ mqtt: CocoaMQTT){
    TRACE()
  }
  func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?){
    delegate?.manager(self, didUpdateConnectionStatus: false)
    TRACE("\(err.description)")
  }

}
extension MQTTManager{

  func TRACE(_ message: String = "", fun: String = #function) {
    let names = fun.components(separatedBy: ":")
    var prettyName: String
    if names.count == 1 {
      prettyName = names[0]
    } else {
      prettyName = names[1]
    }

    if fun == "mqttDidDisconnect(_:withError:)" {
      prettyName = "didDisconect"
    }

    print("[TRACE] [\(prettyName)]: \(message)")
  }
}

extension Optional {
  fileprivate var description: String {
    if let warped = self {
      return "\(warped)"
    }
    return ""
  }
}
