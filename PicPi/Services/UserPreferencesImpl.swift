//
//  UserPreferencesImpl.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation

func injectUserPreferences() -> UserPreferences {
  return UserPreferencesImpl()
}

private class UserPreferencesImpl: UserPreferences {
  private let piIPAddressKey = "Pi1IP"
  private lazy var encoder = JSONEncoder()
  private lazy var decoder = JSONDecoder()

  func add(ipAddress: String) {
    var currentIPs = loadIPAddresses()
    currentIPs.append(ipAddress)
    saveIPAddresses(currentIPs)
  }

  func remove(ipAddress: String) {
    var currentIPs = loadIPAddresses()
    currentIPs = currentIPs.filter { $0 != ipAddress }
    saveIPAddresses(currentIPs)
  }

  func ipAddresses() -> [String] {
    loadIPAddresses()
  }

  private func loadIPAddresses() -> [String] {
    guard
      let ipData = KeyChain.loadKey(piIPAddressKey),
      let ips = try? decoder.decode([String].self, from: ipData)
    else {
      return []
    }

    return ips
  }

  private func saveIPAddresses(_ addresses: [String]) {
    guard let ipData = try? encoder.encode(addresses) else { return }
    _ = KeyChain.save(key: piIPAddressKey, data: ipData)
  }
}
