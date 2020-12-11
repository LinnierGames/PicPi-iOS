//
//  MQTTManager.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/9/20.
//

import Foundation

protocol MQTTManagerDelegate: AnyObject {
  func manager(_ manager: MQTTManager, didUpdateConnectionStatus isConnected: Bool)
 
}

class MQTTManager {
    weak var delegate: MQTTManagerDelegate?

    private func connect() {
        delegate?.manager(self, didUpdateConnectionStatus: true)
    }
    
    func validIP(_ ip : String) {
        if IPAddressValidator(ip) { // try to connect if the IP Address is valid
            connect()
        }
    }
    // check if the IP is vaild before connecting
    private func IPAddressValidator(_ ip : String ) -> Bool {
        let chunks = ip.components(separatedBy: ".")
        if chunks.count != 4 {
            return false
        }
        for chunk in chunks {
            if !validChunk(chunk) {
                return false
            }
        }
        return true
    }
    fileprivate func validChunk(_ chunk : String )-> Bool {
          let chunkArr = chunk.map({Int(String.init($0))})
        if chunkArr.count == 0 || chunkArr.contains(nil) {
            return false
        }
        
        
        for i in 0..<chunk.count {
            if  chunkArr[i]!  < 0 || chunkArr[i]!  > 9  {
                return false
            }
            if chunkArr.count >= 2 && chunkArr[0] == 0 {
                return false
            }
           
        }
        let ip = Int(chunk)!

        return ip >= 0 ||   ip <= 255

    }
}
