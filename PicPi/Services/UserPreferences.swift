/// Basic user preferences.
protocol UserPreferences {
  /// Append the given ip address to the list of saved addresses.
  func add(ipAddress: String)

  /// Remove the given ip address.
  func remove(ipAddress: String)

  /// List of saved ip addresses.
  func ipAddresses() -> [String]
}
