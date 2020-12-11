//
//  KeychainService.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/9/20.
//
import Foundation
import Security
/*
 
 Example usage:

 let int: Int = 555
 let data = Data(  int.utf8)
 let status = KeyChain.save(key: "MyNumber", data: data)
 print("status: ", status)

 if let receivedData = KeyChain.loadKey(  "MyNumber") {
     let result  Int(decoding: receivedData, as: UTF8.self)

     print("result: ", result)
 }
 
 */
class KeyChain {
    
     class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    class  func loadKey(_ key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    class func removeKey(_ key : String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

 
     
       let done =  SecItemDelete(query as CFDictionary)
 

        if done == noErr {
            return true
        } else {
            return false
        }
    }
 
}

 
