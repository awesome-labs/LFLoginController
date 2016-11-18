//
//  LFLoginController.swift
//  LFLoginController
//
//  Created by Lucas Farah on 6/9/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable trailing_whitespace
// swiftlint:disable type_body_length

import UIKit
import AVFoundation
//import OnePasswordExtension

//MARK: - LFTimePickerDelegate
public protocol LFLoginControllerDelegate: class {

	/// LFLoginControllerDelegate: Called after pressing 'Login' or 'Signup
	func loginDidFinish(email: String, password: String, type: LFLoginController.SendType)

	func forgotPasswordTapped()
}

public class LFLoginController: UIViewController {

	// MARK: - Variables

	let domainNames = ["gmail.com",
		"yahoo.com",
		"hotmail.com",
		"aol.com",
		"comcast.net",
		"me.com",
		"msn.com",
		"live.com",
		"sbcglobal.net",
		"ymail.com",
		"att.net",
		"mac.com",
		"cox.net",
		"verizon.net",
		"hotmail.co.uk",
		"bellsouth.net",
		"rocketmail.com",
		"aim.com",
		"yahoo.co.uk",
		"earthlink.net",
		"charter.net",
		"optonline.net",
		"shaw.ca",
		"yahoo.ca",
		"googlemail.com",
		"mail.com",
		"qq.com",
		"btinternet.com",
		"mail.ru",
		"live.co.uk",
		"naver.com",
		"rogers.com",
		"juno.com",
		"yahoo.com.tw",
		"live.ca",
		"walla.com",
		"163.com",
		"roadrunner.com",
		"telus.net",
		"embarqmail.com",
		"hotmail.fr",
		"pacbell.net",
		"sky.com",
		"sympatico.ca",
		"cfl.rr.com",
		"tampabay.rr.com",
		"q.com",
		"yahoo.co.in",
		"yahoo.fr",
		"hotmail.ca",
		"windstream.net",
		"hotmail.it",
		"web.de",
		"asu.edu",
		"gmx.de",
		"gmx.com",
		"insightbb.com",
		"netscape.net",
		"icloud.com",
		"frontier.com",
		"126.com",
		"hanmail.net",
		"suddenlink.net",
		"netzero.net",
		"mindspring.com",
		"ail.com",
		"windowslive.com",
		"netzero.com",
		"yahoo.com.hk",
		"yandex.ru",
		"mchsi.com",
		"cableone.net",
		"yahoo.com.cn",
		"yahoo.es",
		"yahoo.com.br",
		"cornell.edu",
		"ucla.edu",
		"us.army.mil",
		"excite.com",
		"ntlworld.com",
		"usc.edu",
		"nate.com",
		"outlook.com",
		"nc.rr.com",
		"prodigy.net",
		"wi.rr.com",
		"videotron.ca",
		"yahoo.it",
		"yahoo.com.au",
		"umich.edu",
		"ameritech.net",
		"libero.it",
		"yahoo.de",
		"rochester.rr.com",
		"cs.com",
		"frontiernet.net",
		"swbell.net",
		"msu.edu",
		"ptd.net",
		"proxymail.facebook.com",
		"hotmail.es",
		"austin.rr.com",
		"nyu.edu",
		"sina.com",
		"centurytel.net",
		"usa.net",
		"nycap.rr.com",
		"uci.edu",
		"hotmail.de",
		"yahoo.com.sg",
		"email.arizona.edu",
		"yahoo.com.mx",
		"ufl.edu",
		"bigpond.com",
		"unlv.nevada.edu",
		"yahoo.cn",
		"ca.rr.com",
		"google.com",
		"yahoo.co.id",
		"inbox.com",
		"fuse.net",
		"hawaii.rr.com",
		"talktalk.net",
		"gmx.net",
		"walla.co.il",
		"ucdavis.edu",
		"carolina.rr.com",
		"comcast.com",
		"live.fr",
		"blueyonder.co.uk",
		"live.cn",
		"cogeco.ca",
		"abv.bg",
		"tds.net",
		"centurylink.net",
		"yahoo.com.vn",
		"uol.com.br",
		"osu.edu",
		"san.rr.com",
		"rcn.com",
		"umn.edu",
		"live.nl",
		"live.com.au",
		"tx.rr.com",
		"eircom.net",
		"sasktel.net",
		"post.harvard.edu",
		"snet.net",
		"wowway.com",
		"live.it",
		"hoteltonight.com",
		"att.com",
		"vt.edu",
		"rambler.ru",
		"temple.edu",
		"cinci.rr.com"]

	var txtEmail: AutoCompleteTextField!
	var txtPassword: UITextField!

	var imgvUserIcon: UIImageView!
	var imgvPasswordIcon: UIImageView!
	var imgvLogo: UIImageView!

	var loginView: UIView!
	var bottomTxtEmailView: UIView!
	var bottomTxtPasswordView: UIView!

	var butLogin: UIButton!
	var butSignup: UIButton!
	var butForgotPassword: UIButton!

	// 1Password
	var butOnePassword: UIButton!
	var appName = ""
	var appUrl = ""

	var isLogin = true

	public weak var delegate: LFLoginControllerDelegate?
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

	public override func viewWillDisappear(_ animated: Bool) {

		// Adding Navigation bar again
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}

	public override func viewWillAppear(_ animated: Bool) {

		// Removing Navigation bar
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}

	public override func viewWillLayoutSubviews() {
		// Do any additional setup after loading the view, typically from a nib.

	}

	convenience init() {
		self.init(nibName: nil, bundle: nil)

		print("layout")
		view.backgroundColor = UIColor(red: 224 / 255, green: 68 / 255, blue: 98 / 255, alpha: 1)

		// setupVideoBackgrond()
		// setupLoginLogo()

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

			let shade = UIView(frame: self.view.frame)
			shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
			view.addSubview(shade)
			view.sendSubview(toBack: shade)

			theURL = url

			var avPlayer = AVPlayer()
			avPlayer = AVPlayer(url: theURL as URL)
			let avPlayerLayer = AVPlayerLayer(player: avPlayer)
			avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
			avPlayer.volume = 0
			avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none

			avPlayerLayer.frame = view.layer.bounds

			let layer = UIView(frame: self.view.frame)
			view.backgroundColor = UIColor.clear
			view.layer.insertSublayer(avPlayerLayer, at: 0)
			view.addSubview(layer)
			view.sendSubview(toBack: layer)

            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
//			NotificationCenter.default().addObserver(self,
//				selector: #selector(playerItemDidReachEnd(_:)),
//				name: AVPlayerItemDidPlayToEndTimeNotification,
//				object: avPlayer.currentItem)

			avPlayer.play()
		}
	}

	func playerItemDidReachEnd(notification: NSNotification) {

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

			view.addSubview(imgvLogo)
		}
	}

	// MARK: Login View
	func setupLoginView() {

		let loginX: CGFloat = 20
		let loginY = CGFloat(130 + 40)
		let loginWidth = self.view.bounds.width - 40
		let loginHeight: CGFloat = self.view.bounds.height - loginY - 30
		print(loginHeight)

		loginView = UIView(frame: CGRect(x: loginX, y: loginY, width: loginWidth, height: loginHeight))
	}

	func setupEmailField() {

		imgvUserIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		let bundle = Bundle(for: LFLoginController.self)
		imgvUserIcon.image = UIImage(named: "user", in: bundle, compatibleWith: nil)
		loginView.addSubview(imgvUserIcon)

		txtEmail = AutoCompleteTextField(frame: CGRect(x: imgvUserIcon.frame.width + 5, y: 0, width: loginView.frame.width - imgvUserIcon.frame.width - 5, height: 30))
		txtEmail.delegate = self
		txtEmail.autoCompleteTextFieldDataSource = self
		txtEmail.setDelimiter("@")
		txtEmail.dataSource = self

		// Show right side complete button
		txtEmail.showAutoCompleteButton(autoCompleteButtonViewMode: .whileEditing)

		txtEmail.returnKeyType = .next
		txtEmail.autocapitalizationType = .none
		txtEmail.autocorrectionType = .no
		txtEmail.textColor = UIColor.white
		txtEmail.keyboardType = .emailAddress
		txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter your Email", attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
		loginView.addSubview(txtEmail)

		bottomTxtEmailView = UIView(frame: CGRect(x: txtEmail.frame.minX - imgvUserIcon.frame.width - 5, y: txtEmail.frame.maxY + 5, width: loginView.frame.width, height: 1))
		bottomTxtEmailView.backgroundColor = .white
		bottomTxtEmailView.alpha = 0.5
		loginView.addSubview(bottomTxtEmailView)
	}

	func setupPasswordField() {

		imgvPasswordIcon = UIImageView(frame: CGRect(x: 0, y: txtEmail.frame.maxY + 10, width: 30, height: 30))

		let bundle = Bundle(for: LFLoginController.self)
		imgvPasswordIcon.image = UIImage(named: "password", in: bundle, compatibleWith: nil)
		loginView.addSubview(imgvPasswordIcon)

		txtPassword = UITextField(frame: CGRect(x: imgvPasswordIcon.frame.width + 5, y: txtEmail.frame.maxY + 10, width: loginView.frame.width - imgvPasswordIcon.frame.width - 5, height: 30))
		txtPassword.delegate = self
		txtPassword.returnKeyType = .done
		txtPassword.isSecureTextEntry = true
		txtPassword.textColor = UIColor.white
		txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
		loginView.addSubview(txtPassword)

		bottomTxtPasswordView = UIView(frame: CGRect(x: txtPassword.frame.minX - imgvPasswordIcon.frame.width - 5, y: txtPassword.frame.maxY + 5, width: loginView.frame.width, height: 1))
		bottomTxtPasswordView.backgroundColor = .white
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

		butLogin.setTitle("Login", for: .normal)
		butLogin.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
		butLogin.layer.cornerRadius = 5
		butLogin.layer.borderWidth = 1
		butLogin.layer.borderColor = UIColor.clear.cgColor
		loginView.addSubview(butLogin)
	}

	func setupSignupButton() {

		butSignup = UIButton(frame: CGRect(x: 0, y: loginView.frame.maxY - 200, width: loginView.frame.width, height: 40))

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = NSAttributedString(string: "Don't have an account? Sign up", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white])
		butSignup.setAttributedTitle(titleString, for: .normal)
		butSignup.alpha = 0.7

		butSignup.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
		loginView.addSubview(butSignup)
	}

	func setupForgotPasswordButton() {

		butForgotPassword = UIButton(frame: CGRect(x: 0, y: butLogin.frame.maxY, width: loginView.frame.width, height: 40))

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = NSAttributedString(string: "Forgot password", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white])
		butForgotPassword.setAttributedTitle(titleString, for: .normal)
		butForgotPassword.alpha = 0.7

		butForgotPassword.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
		loginView.addSubview(butForgotPassword)
	}

	public func setupOnePassword(appName: String, appUrl: String) {

		self.appName = appName
		self.appUrl = appUrl

		butOnePassword = UIButton(frame: CGRect(x: txtPassword.frame.maxX - imgvPasswordIcon.frame.width, y: txtPassword.frame.origin.y, width: imgvPasswordIcon.frame.width, height: imgvPasswordIcon.frame.height))
		butOnePassword.setImage(UIImage(named: "onepassword-button-light"), for: .normal)
//		butOnePassword.addTarget(self, action: #selector(forgotPasswordTapped), forControlEvents: .touchUpInside)
//		butOnePassword.hidden = !OnePasswordExtension.sharedExtension().isAppExtensionAvailable()
		loginView.addSubview(butOnePassword)
		print(butOnePassword.frame)
	}

	// MARK: Button Handlers
	func sendTapped() {

		let type = isLogin ? SendType.Login : SendType.Signup

		delegate?.loginDidFinish(email: self.txtEmail.text!, password: self.txtPassword.text!, type: type)
	}

	func signupTapped() {

		toggleLoginSignup()
	}

	func forgotPasswordTapped() {

		delegate?.forgotPasswordTapped()
	}

//	func onePasswordTapped() {
//
//		if isLogin {
//			OnePasswordExtension.sharedExtension().findLoginForURLString(appUrl, forViewController: self, sender: nil) { (dicLogin, error) in
//
//				if let dic = dicLogin , dic.count == 0 {
//
//					if Int32((error?.code)!) != AppExtensionErrorCodeCancelledByUser {
//
//						print("1Password Extension error: \(error)")
//					}
//					return
//				}
//
//				if let dic = dicLogin, let email = dic[AppExtensionUsernameKey] as? String, let password = dic[AppExtensionPasswordKey] as? String {
//					self.txtEmail.text = email
//					self.txtPassword.text = password
//				}
//			}
//		} else {
//
//			let loginDetails: [NSObject: AnyObject] = [AppExtensionTitleKey: appName,
//				AppExtensionUsernameKey: (self.txtEmail.text != nil ? self.txtEmail.text : "")!,
//				AppExtensionPasswordKey: (self.txtPassword.text != nil ? self.txtPassword.text : "")!,
//			]
//
//			OnePasswordExtension.sharedExtension().storeLoginForURLString(appUrl, loginDetails: loginDetails, passwordGenerationOptions: nil, forViewController: self, sender: nil, completion: { (loginDictionary, error) in
//
//				if let dic = loginDictionary , dic.count == 0 {
//
//					if Int32((error?.code)!) != AppExtensionErrorCodeCancelledByUser {
//
//						print("1Password Extension error: \(error)")
//					}
//					return
//				}
//
//				if let dic = loginDictionary, let email = dic[AppExtensionUsernameKey] as? String, let password = dic[AppExtensionPasswordKey] as? String {
//					self.txtEmail.text = email
//					self.txtPassword.text = password
//				}
//			})
//		}
//	}

	func toggleLoginSignup() {

		isLogin = !isLogin

		UIView.animate(withDuration: 0.5, animations: {
			self.butLogin.alpha = 0
			UIView.animate(withDuration: 0.5, animations: {
				self.butLogin.alpha = 1
			})
		})

		let login = isLogin ? "Login" : "Signup"
		self.butLogin.setTitle(login, for: .normal)

		let signup = isLogin ? "Don't an account? Sign up" : "Have an account? Login"

		let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
		let titleString = NSAttributedString(string: signup, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white])
		self.butSignup.setAttributedTitle(titleString, for: .normal)

	}

	// MARK: - Wrong Info Shake Animations

	public func wrongInfoShake() {

		self.setWrongUI()
		self.txtEmail.shake()
		self.txtPassword.shake()
		self.setRightUI()
	}

	func setWrongUI() {

		UIView.animate(withDuration: 5) {

			self.butLogin.backgroundColor = .red
			self.butLogin.setTitle("Wrong Info", for: .normal)
			self.bottomTxtEmailView.backgroundColor = .red
			self.bottomTxtPasswordView.backgroundColor = .red
		}
	}

	func setRightUI() {

		UIView.animate(withDuration: 1) {

			self.butLogin.removeFromSuperview()
			self.setupLoginButton()
			self.bottomTxtEmailView.backgroundColor = .white
			self.bottomTxtPasswordView.backgroundColor = .white
		}
	}
}

extension UIView {
	func shake() {
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		animation.duration = 0.6
		animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
		layer.add(animation, forKey: "shake")
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

				self.bottomTxtPasswordView.alpha = 0.2
				self.imgvPasswordIcon.alpha = 0.2
			})
		} else {

			UIView.animate(withDuration: 1, animations: {
				self.imgvUserIcon.alpha = 0.2
				self.bottomTxtEmailView.alpha = 0.2

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
		self.imgvUserIcon.alpha = 1
		self.bottomTxtEmailView.alpha = 1

		self.bottomTxtPasswordView.alpha = 1
		self.imgvPasswordIcon.alpha = 1

	}

	// Dealing with return key on keyboard
	public func textFieldShouldReturn(_
        textField: UITextField) -> Bool {

		if textField == txtEmail {

			self.txtPassword.becomeFirstResponder()
		} else {

			self.txtPassword.resignFirstResponder()
		}

		return true
	}
}

extension LFLoginController: AutoCompleteTextFieldDataSource {

	public func autoCompleteTextFieldDataSource(_ autoCompleteTextField: AutoCompleteTextField) -> [String] {

		return domainNames
	}
}
