//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 20.09.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

enum ViewControllerLifeCycleState: String {
    case appearing, appeared, disappearing, disappeared, notLoaded, loaded, layouting, layouted
}

class ProfileViewController: UIViewController {
    
    private var currentState = ViewControllerLifeCycleState.notLoaded
    
    private func viewControllerMoved(to state: ViewControllerLifeCycleState) {
        print("View controller moved from state \(currentState) to state \(state)")
        currentState = state
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Function: \(#function))")
        viewControllerMoved(to: .loaded)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Function: \(#function))")
        viewControllerMoved(to: .appearing)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Function: \(#function))")
        viewControllerMoved(to: .appeared)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("Function: \(#function))")
        viewControllerMoved(to: .layouting)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("Function: \(#function))")
        viewControllerMoved(to: .layouted)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Function: \(#function))")
        viewControllerMoved(to: .disappearing)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Function: \(#function))")
        viewControllerMoved(to: .disappeared)
    }
    
    viewDidI
}

