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

class ViewController: UIViewController {

	let controller = LFLoginController()
  
	override func viewDidLoad() {
		super.viewDidLoad()

    controller.delegate = self
    
    //Customizations
//    controller.videoURL = NSBundle.mainBundle().URLForResource("Earth", withExtension: "mov")!
//    controller.logo = UIImage(named: "user")
//    controller.loginButtonColor = UIColor.purpleColor()
	}

  @IBAction func butLoginTapped(_ sender: AnyObject) {
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension ViewController: LFLoginControllerDelegate {
  
  func loginDidFinish(_ email: String, password: String, type: LFLoginController.SendType) {
    
    print(email)
    print(password)
    print(type)
  }
  
  func forgotPasswordTapped() {
    
    print("forgot password")
  }
}
