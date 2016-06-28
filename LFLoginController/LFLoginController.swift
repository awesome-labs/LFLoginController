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
	func loginDidFinish(_ email: String, password: String, type: LFLoginController.SendType)
  
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
    
    case login
    case signup
  }

	// MARK: Customizations
  
  ///URL of the background video
	public var videoURL: URL? {
		didSet {
			setupVideoBackgrond()
		}
	}
  
  ///Logo on the top of the Login page
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

	public override func viewWillLayoutSubviews() {
		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = UIColor(red: 224 / 255, green: 68 / 255, blue: 98 / 255, alpha: 1)

		// Removing Navigation bar
		self.navigationController?.setNavigationBarHidden(true, animated: true)

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

		var theURL = URL(fileURLWithPath: "")
		if let url = videoURL {

			theURL = url
		} else {

			theURL = Bundle.main().urlForResource("PolarBear", withExtension: "mov")!
		}

		var avPlayer = AVPlayer()
		avPlayer = AVPlayer(url: theURL)
		let avPlayerLayer = AVPlayerLayer(player: avPlayer)
		avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		avPlayer.volume = 0
		avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none

		avPlayerLayer.frame = view.layer.bounds

		let layer = UIView(frame: self.view.frame)
		layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		view.backgroundColor = UIColor.clear()
		view.layer.insertSublayer(avPlayerLayer, at: 0)
		view.addSubview(layer)

		NotificationCenter.default().addObserver(self,
			selector: #selector(LFLoginController.playerItemDidReachEnd(_:)),
			name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
			object: avPlayer.currentItem)

		avPlayer.play()
	}

	func playerItemDidReachEnd(_ notification: Notification) {

		if let p = notification.object as? AVPlayerItem {
			p.seek(to: kCMTimeZero)
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
		txtEmail.returnKeyType = .next
		txtEmail.autocapitalizationType = .none
		txtEmail.textColor = UIColor.white()
		txtEmail.keyboardType = .emailAddress
		txtEmail.attributedPlaceholder = AttributedString(string: "Enter your Email", attributes: [NSForegroundColorAttributeName: UIColor.white().withAlphaComponent(0.5)])
		loginView.addSubview(txtEmail)

		bottomTxtEmailView = UIView(frame: CGRect(x: txtEmail.frame.minX - imgvUserIcon.frame.width - 5, y: txtEmail.frame.maxY + 5, width: loginView.frame.width, height: 1))
		bottomTxtEmailView.backgroundColor = .white()
		bottomTxtEmailView.alpha = 0.5
		loginView.addSubview(bottomTxtEmailView)
	}

	func setupPasswordField() {

		imgvPasswordIcon = UIImageView(frame: CGRect(x: 0, y: txtEmail.frame.maxY + 10, width: 30, height: 30))
		imgvPasswordIcon.image = UIImage(named: "password")
		loginView.addSubview(imgvPasswordIcon)

		txtPassword = UITextField(frame: CGRect(x: imgvPasswordIcon.frame.width + 5, y: txtEmail.frame.maxY + 10, width: loginView.frame.width - imgvPasswordIcon.frame.width - 5, height: 30))
		txtPassword.delegate = self
		txtPassword.returnKeyType = .done
		txtPassword.isSecureTextEntry = true
		txtPassword.textColor = UIColor.white()
		txtPassword.attributedPlaceholder = AttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white().withAlphaComponent(0.5)])
		loginView.addSubview(txtPassword)

		bottomTxtPasswordView = UIView(frame: CGRect(x: txtPassword.frame.minX - imgvPasswordIcon.frame.width - 5, y: txtPassword.frame.maxY + 5, width: loginView.frame.width, height: 1))
		bottomTxtPasswordView.backgroundColor = .white()
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

		butLogin.setTitle("Login", for: UIControlState())
		butLogin.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
		butLogin.layer.cornerRadius = 5
		butLogin.layer.borderWidth = 1
		butLogin.layer.borderColor = UIColor.clear().cgColor
		loginView.addSubview(butLogin)
	}

	func setupSignupButton() {

		butSignup = UIButton(frame: CGRect(x: 0, y: loginView.frame.maxY - 200, width: loginView.frame.width, height: 40))

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = AttributedString(string: "Don't have an account? Sign up", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white()])
		butSignup.setAttributedTitle(titleString, for: UIControlState())
		butSignup.alpha = 0.7

		butSignup.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
		loginView.addSubview(butSignup)
	}

	// MARK: Button Handlers
	func sendTapped() {

		let type = isLogin ? SendType.login : SendType.signup

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

		UIView.animate(withDuration: 0.5, animations: {
			self.butLogin.alpha = 0
			UIView.animate(withDuration: 0.5, animations: {
				self.butLogin.alpha = 1
			})
		})

		let login = isLogin ? "Login" : "Signup"
		self.butLogin.setTitle(login, for: UIControlState())

		let signup = isLogin ? "Don't an account? Sign up" : "Have an account? Login"

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = AttributedString(string: signup, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white()])
		self.butSignup.setAttributedTitle(titleString, for: UIControlState())
	}

	func setupForgotPasswordButton() {

		butForgotPassword = UIButton(frame: CGRect(x: 0, y: butLogin.frame.maxY, width: loginView.frame.width, height: 40))

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = AttributedString(string: "Forgot password", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white()])
		butForgotPassword.setAttributedTitle(titleString, for: UIControlState())
		butForgotPassword.alpha = 0.7

		butForgotPassword.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
		loginView.addSubview(butForgotPassword)
	}
}

//MARK: - UITextFieldDelegate
extension LFLoginController: UITextFieldDelegate {

	// Animating alpha of bottom line and password icons
	public func textFieldDidBeginEditing(_ textField: UITextField) {

		// Moving Signup button up
		UIView.animate(withDuration: 0.2, animations: { () -> Void in

			self.butSignup.frame = CGRect(x: 0, y: self.butLogin.frame.maxY, width: self.loginView.frame.width, height: 40)
			self.butForgotPassword.isHidden = true
		})

		if textField == txtEmail {

			UIView.animate(withDuration: 1, animations: {
				self.bottomTxtEmailView.alpha = 1
				self.imgvUserIcon.alpha = 1

				self.bottomTxtPasswordView.alpha = 0.7
				self.imgvPasswordIcon.alpha = 0.7
			})
		} else {

			UIView.animate(withDuration: 1, animations: {
				self.imgvUserIcon.alpha = 0.7
				self.bottomTxtEmailView.alpha = 0.7

				self.bottomTxtPasswordView.alpha = 1
				self.imgvPasswordIcon.alpha = 1
			})
		}
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {

		// Moving signup button down, showing forgot password
		UIView.animate(withDuration: 0.2, animations: { () -> Void in

			self.butSignup.frame = CGRect(x: 0, y: self.loginView.frame.maxY - 200, width: self.loginView.frame.width, height: 40)
		})

		self.butForgotPassword.isHidden = false
	}

	// Dealing with return key on keyboard
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		if textField == txtEmail {

			self.txtPassword.becomeFirstResponder()
		} else {

			self.txtPassword.resignFirstResponder()
		}

		return true
	}
}
