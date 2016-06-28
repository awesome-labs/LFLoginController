//
//  LFLoginController.swift
//  LFLoginController
//
//  Created by Lucas Farah on 6/9/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable trailing_whitespace

import UIKit
import AVFoundation

//MARK: - LFTimePickerDelegate
public protocol LFLoginControllerDelegate: class {

	/// LFLoginControllerDelegate: Called after pressing 'Login' or 'Signup
	func loginDidFinish(email: String, password: String, type: LFLoginController.SendType)

	func forgotPasswordTapped()
}

public class LFLoginController: UIViewController {

	// MARK: - Variables

	var txtEmail = UITextField()
	var txtPassword = UITextField()

	var imgvUserIcon = UIImageView()
	var imgvPasswordIcon = UIImageView()
	var imgvLogo = UIImageView()

	var loginView = UIView()
	var bottomTxtEmailView = UIView()
	var bottomTxtPasswordView = UIView()

	var butLogin = UIButton()
	var butSignup = UIButton()
	var butForgotPassword = UIButton()

	var isLogin = true

	public var delegate: LFLoginControllerDelegate?
	public enum SendType {

		case Login
		case Signup
	}

	// MARK: Customizations

	/// URL of the background video
	public var videoURL: NSURL? {
		didSet {
			setupVideoBackgrond()
		}
	}

	/// Logo on the top of the Login page
	public var logo: UIImage? {
		didSet {
			setupLoginLogo()
		}
	}

	public var loginButtonColor: UIColor? {
		didSet {
			setupLoginButton()
		}
	}

	// MARK: - Methods

	override public func viewDidLoad() {
		super.viewDidLoad()

	}

	public override func viewWillDisappear(animated: Bool) {

		// Adding Navigation bar again
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}

	public override func viewWillAppear(animated: Bool) {

		// Removing Navigation bar
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}

	public override func viewWillLayoutSubviews() {
		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = UIColor(red: 224 / 255, green: 68 / 255, blue: 98 / 255, alpha: 1)

		setupVideoBackgrond()
		setupLoginLogo()

		// Login
		setupLoginView()
		setupEmailField()
		setupPasswordField()
		setupLoginButton()
		setupSignupButton()
		setupForgotPasswordButton()

		view.addSubview(loginView)
	}

	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: Background Video Player
	func setupVideoBackgrond() {

		var theURL = NSURL()
		if let url = videoURL {

			theURL = url
		} else {

			theURL = NSBundle.mainBundle().URLForResource("PolarBear", withExtension: "mov")!
		}

		var avPlayer = AVPlayer()
		avPlayer = AVPlayer(URL: theURL)
		let avPlayerLayer = AVPlayerLayer(player: avPlayer)
		avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		avPlayer.volume = 0
		avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.None

		avPlayerLayer.frame = view.layer.bounds

		let layer = UIView(frame: self.view.frame)
		layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		view.backgroundColor = UIColor.clearColor()
		view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
		view.addSubview(layer)

		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: #selector(LFLoginController.playerItemDidReachEnd(_:)),
			name: AVPlayerItemDidPlayToEndTimeNotification,
			object: avPlayer.currentItem)

		avPlayer.play()
	}

	func playerItemDidReachEnd(notification: NSNotification) {

		if let p = notification.object as? AVPlayerItem {
			p.seekToTime(kCMTimeZero)
		}
	}

	// MARK: Login Logo
	func setupLoginLogo() {

		let logoFrame = CGRect(x: (self.view.bounds.width - 100) / 2, y: 30, width: 100, height: 100)
		imgvLogo = UIImageView(frame: logoFrame)

		if let loginLogo = logo {

			imgvLogo.image = loginLogo
		} else {

			imgvLogo.image = UIImage(named: "AwesomeLabsLogoWhite")
		}
		view.addSubview(imgvLogo)
	}

	// MARK: Login View
	func setupLoginView() {

		let loginX: CGFloat = 20
		let loginY = imgvLogo.frame.maxY + 40
		let loginWidth = self.view.bounds.width - 40
		let loginHeight: CGFloat = self.view.bounds.height - loginY - 30
		print(loginHeight)

		loginView = UIView(frame: CGRect(x: loginX, y: loginY, width: loginWidth, height: loginHeight))
	}

	func setupEmailField() {

		imgvUserIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		imgvUserIcon.image = UIImage(named: "user")
		loginView.addSubview(imgvUserIcon)

		txtEmail = UITextField(frame: CGRect(x: imgvUserIcon.frame.width + 5, y: 0, width: loginView.frame.width - imgvUserIcon.frame.width - 5, height: 30))
		txtEmail.delegate = self
		txtEmail.returnKeyType = .Next
		txtEmail.autocapitalizationType = .None
		txtEmail.textColor = UIColor.whiteColor()
		txtEmail.keyboardType = .EmailAddress
		txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter your Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
		loginView.addSubview(txtEmail)

		bottomTxtEmailView = UIView(frame: CGRect(x: txtEmail.frame.minX - imgvUserIcon.frame.width - 5, y: txtEmail.frame.maxY + 5, width: loginView.frame.width, height: 1))
		bottomTxtEmailView.backgroundColor = .whiteColor()
		bottomTxtEmailView.alpha = 0.5
		loginView.addSubview(bottomTxtEmailView)
	}

	func setupPasswordField() {

		imgvPasswordIcon = UIImageView(frame: CGRect(x: 0, y: txtEmail.frame.maxY + 10, width: 30, height: 30))
		imgvPasswordIcon.image = UIImage(named: "password")
		loginView.addSubview(imgvPasswordIcon)

		txtPassword = UITextField(frame: CGRect(x: imgvPasswordIcon.frame.width + 5, y: txtEmail.frame.maxY + 10, width: loginView.frame.width - imgvPasswordIcon.frame.width - 5, height: 30))
		txtPassword.delegate = self
		txtPassword.returnKeyType = .Done
		txtPassword.secureTextEntry = true
		txtPassword.textColor = UIColor.whiteColor()
		txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
		loginView.addSubview(txtPassword)

		bottomTxtPasswordView = UIView(frame: CGRect(x: txtPassword.frame.minX - imgvPasswordIcon.frame.width - 5, y: txtPassword.frame.maxY + 5, width: loginView.frame.width, height: 1))
		bottomTxtPasswordView.backgroundColor = .whiteColor()
		bottomTxtPasswordView.alpha = 0.5
		loginView.addSubview(bottomTxtPasswordView)
	}

	func setupLoginButton() {

		butLogin = UIButton(frame: CGRect(x: 0, y: bottomTxtPasswordView.frame.maxY + 30, width: loginView.frame.width, height: 40))

		var buttonColor = UIColor()
		if let color = loginButtonColor {

			buttonColor = color
		} else {
			buttonColor = UIColor(red: 80 / 255, green: 185 / 255, blue: 167 / 255, alpha: 0.8)
		}
		butLogin.backgroundColor = buttonColor

		butLogin.setTitle("Login", forState: .Normal)
		butLogin.addTarget(self, action: #selector(sendTapped), forControlEvents: .TouchUpInside)
		butLogin.layer.cornerRadius = 5
		butLogin.layer.borderWidth = 1
		butLogin.layer.borderColor = UIColor.clearColor().CGColor
		loginView.addSubview(butLogin)
	}

	func setupSignupButton() {

		butSignup = UIButton(frame: CGRect(x: 0, y: loginView.frame.maxY - 200, width: loginView.frame.width, height: 40))

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = NSAttributedString(string: "Don't have an account? Sign up", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()])
		butSignup.setAttributedTitle(titleString, forState: .Normal)
		butSignup.alpha = 0.7

		butSignup.addTarget(self, action: #selector(signupTapped), forControlEvents: .TouchUpInside)
		loginView.addSubview(butSignup)
	}

	// MARK: Button Handlers
	func sendTapped() {

		let type = isLogin ? SendType.Login : SendType.Signup

		delegate?.loginDidFinish(self.txtEmail.text!, password: self.txtPassword.text!, type: type)
	}

	func signupTapped() {

		toggleLoginSignup()
	}

	func forgotPasswordTapped() {

		delegate?.forgotPasswordTapped()
	}

	func toggleLoginSignup() {

		isLogin = !isLogin

		UIView.animateWithDuration(0.5, animations: {
			self.butLogin.alpha = 0
			UIView.animateWithDuration(0.5, animations: {
				self.butLogin.alpha = 1
			})
		})

		let login = isLogin ? "Login" : "Signup"
		self.butLogin.setTitle(login, forState: .Normal)

		let signup = isLogin ? "Don't an account? Sign up" : "Have an account? Login"

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = NSAttributedString(string: signup, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()])
		self.butSignup.setAttributedTitle(titleString, forState: .Normal)
	}

	func setupForgotPasswordButton() {

		butForgotPassword = UIButton(frame: CGRect(x: 0, y: butLogin.frame.maxY, width: loginView.frame.width, height: 40))

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = NSAttributedString(string: "Forgot password", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()])
		butForgotPassword.setAttributedTitle(titleString, forState: .Normal)
		butForgotPassword.alpha = 0.7

		butForgotPassword.addTarget(self, action: #selector(forgotPasswordTapped), forControlEvents: .TouchUpInside)
		loginView.addSubview(butForgotPassword)
	}
}

//MARK: - UITextFieldDelegate
extension LFLoginController: UITextFieldDelegate {

	// Animating alpha of bottom line and password icons
	public func textFieldDidBeginEditing(textField: UITextField) {

		// Moving Signup button up
		UIView.animateWithDuration(0.2, animations: { () -> Void in

			self.butSignup.frame = CGRect(x: 0, y: self.butLogin.frame.maxY, width: self.loginView.frame.width, height: 40)
			self.butForgotPassword.hidden = true
		})

		if textField == txtEmail {

			UIView.animateWithDuration(1, animations: {
				self.bottomTxtEmailView.alpha = 1
				self.imgvUserIcon.alpha = 1

				self.bottomTxtPasswordView.alpha = 0.7
				self.imgvPasswordIcon.alpha = 0.7
			})
		} else {

			UIView.animateWithDuration(1, animations: {
				self.imgvUserIcon.alpha = 0.7
				self.bottomTxtEmailView.alpha = 0.7

				self.bottomTxtPasswordView.alpha = 1
				self.imgvPasswordIcon.alpha = 1
			})
		}
	}

	public func textFieldDidEndEditing(textField: UITextField) {

		// Moving signup button down, showing forgot password
		UIView.animateWithDuration(0.2, animations: { () -> Void in

			self.butSignup.frame = CGRect(x: 0, y: self.loginView.frame.maxY - 200, width: self.loginView.frame.width, height: 40)
		})

		self.butForgotPassword.hidden = false
	}

	// Dealing with return key on keyboard
	public func textFieldShouldReturn(textField: UITextField) -> Bool {

		if textField == txtEmail {

			self.txtPassword.becomeFirstResponder()
		} else {

			self.txtPassword.resignFirstResponder()
		}

		return true
	}
}
