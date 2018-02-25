//
//  ViewController.swift
//  LFLoginController
//
//  Created by Lucas Farah on 6/10/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable trailing_whitespace

import UIKit
import LFLoginController

class ViewController: UIViewController {
    
    let controller = LFLoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        
        // Customizations
        controller.logo = UIImage(named: "AwesomeLabsLogoWhite")
        controller.isSignupSupported = false
        controller.backgroundColor = UIColor(red: 224 / 255, green: 68 / 255, blue: 98 / 255, alpha: 1)
        controller.videoURL = Bundle.main.url(forResource: "PolarBear", withExtension: "mov")!
		controller.loginButtonColor = UIColor.purple
//		controller.setupOnePassword("YourAppName", appUrl: "YourAppURL")
    }
    
    @IBAction func butLoginTapped(sender: AnyObject) {
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ViewController: LFLoginControllerDelegate {
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
        
        // Implement your server call here
        
        print(email)
        print(password)
        print(type)
        
        // Example
        if type == .Login && password != "1234" {
            
            controller.wrongInfoShake()
        } else {
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func forgotPasswordTapped(email: String) {
        print("forgot password: \(email)")
    }
}
