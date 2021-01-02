//
//  AppDelegate.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let homeViewController = HomeViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UINavigationController(rootViewController: homeViewController)
    window?.makeKeyAndVisible()

    return true
  }
}
