//
//  ViewController.swift
//  Sample Project 2 - Nodejs
//
//  Created by Erick Sanchez on 12/10/20.
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

  @IBAction func pressConnect(_ sender: Any) {
    guard
      let ipAddress = textFieldIPAddress.text, ipAddress.isEmpty != true,
      let topic = textFieldTopicSubscription.text, topic.isEmpty != true
    else {
        return
    }

//    mqttManager = MQTTManager(identifier: "idk", host: ipAddress, topic: topic)
//    mqttManager?.connect()
//    mqttManager?.delegate = self
  }

  @IBAction func pressSend(_ sender: Any) {
    guard let host = textFieldIPAddress.text, host.isEmpty != true else { return }

    let url = URL(string: "\(host)/photos/upload")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let imageData = #imageLiteral(resourceName: "photo").pngData()!
    let payload = Payload(image: imageData)
    request.httpBody = try! JSONEncoder().encode(payload)

    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
      if let error = error {
        print(request)
        return assertionFailure(error.localizedDescription)
      }

      guard let data = data else {
        return assertionFailure("no error and no data provided")
      }

      do {
        let response = try JSONDecoder().decode(PayloadResponse.self, from: data)
        print("Response!", response)
      } catch {
        assertionFailure("failed to decode: \(error.localizedDescription)")
      }
    }
    task.resume()
  }
}

struct Payload: Encodable {
  let image: Data
}

struct PayloadResponse: Decodable {
  let message: String
  let payload: String
}
