//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 20.09.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

enum AppState: String {
    case notRunning, inactive, active, background, suspended
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var currentState = AppState.notRunning
    
    private func applicationMoved(to state: AppState) {
        if (currentState == state && state == .background) {
            currentState = .suspended
            applicationMoved(to: .background)
            
            return
        }
        
        print("Application moved from state \(currentState) to state \(state)\n")
        currentState = state
    }
    
    private func printCurrentState() {
        print("Current state: \(currentState)\n")
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        print("Function: \(#function)")
        applicationMoved(to: .inactive)
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("Function: \(#function)")
        printCurrentState()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Function: \(#function)")
        applicationMoved(to: .active)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("Function: \(#function)")
        applicationMoved(to: .inactive)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Function: \(#function)")
        applicationMoved(to: .background)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Function: \(#function)")
        applicationMoved(to: .inactive)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // App move to "not running" only from "suspended"
        currentState = .suspended
        applicationMoved(to: .notRunning)
    }
}

