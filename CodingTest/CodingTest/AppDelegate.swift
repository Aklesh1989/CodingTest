//
//  AppDelegate.swift
//  CodingTest
//
//  Created by Aklesh on 21/11/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    application.statusBarStyle = .lightContent
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0), NSAttributedString.Key.foregroundColor: UIColor.white]
    UINavigationBar.appearance().tintColor = .white


    return true
  }



}

