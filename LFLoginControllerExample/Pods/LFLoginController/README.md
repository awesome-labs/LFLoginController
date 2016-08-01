# LFLoginController
> Customizable login screen, written in Swift

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

Creating Login screens is boring and repetitive. What about implementing and customizing them in **less then 10 lines of code**?

![](LFLoginControllerDemo.gif)

## Features

- [x] Login
- [x] Signup
- [x] Forgot password
- [x] Ready for all iPhone screen sizes
- [x] 100% in Swift :large_orange_diamond:

## Requirements

- iOS 9.0+
- Xcode 7.3

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `LFLoginController` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'LFLoginController'
```

To get the full benefits import `LFLoginController` wherever you import UIKit

``` swift
import UIKit
import LFLoginController
```
#### Carthage
Create a `Cartfile` that lists the framework and run `carthage bootstrap`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/LFLoginController.framework` to an iOS project.

```
github "awesome-labs/LFLoginController"
```
#### Manually
1. Download and drop ```LFLoginController.swift``` in your project.  
2. Congratulations!  

## Usage example

```swift
//1. Create a LFLoginController instance
let loginController = LFLoginController()

//2. Present the timePicker
self.navigationController?.pushViewController(loginController, animated: true)

//3. Implement the LFLoginControllerDelegate
extension ExampleViewController: LFLoginControllerDelegate {

    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {

        print(email)
        print(password)
        print(type)
	}
	
    func forgotPasswordTapped() {
    
    	print("forgot password")
  }

}
```

## Customizations
- ```logo: UIImage?```
- ```loginButtonColor: UIColor?```
- ```videoURL: NSURL?```

## Release History

* 0.2.1
    * CHANGE: Update docs (module code remains unchanged)
* 0.2.0
    * CHANGE: Remove `setDefaultXYZ()`
    * ADD: Add `init()`
* 0.1.1
    * FIX: Crash when calling `baz()` (Thanks @GenerousContributorName!)
* 0.1.0
    * The first proper release
    * CHANGE: Rename `foo()` to `bar()`
* 0.0.1
    * Work in progress

## Contribute

We would love for you to contribute to **LFLoginController**, check the ``LICENSE`` file for more info.

## Meta

Lucas Farah – [@7farah7](https://twitter.com/7farah7) – contact@lucasfarah.me

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/awesome-labs](https://github.com/awesome-labs/)

[swift-image]:https://img.shields.io/badge/swift-2.2-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
