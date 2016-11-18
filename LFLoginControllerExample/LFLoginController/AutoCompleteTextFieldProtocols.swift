//
//  AutoCompleteTextFieldProtocols.swift
//  Pods
//
//  Created by Neil Francis Hipona on 16/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation
import UIKit


// MARK: - AutoCompleteTextField Protocol

public protocol AutoCompleteTextFieldDataSource: NSObjectProtocol {
    
    // Required protocols
    
    func autoCompleteTextFieldDataSource(_ autoCompleteTextField: AutoCompleteTextField) -> [String] // called when in need of suggestions.
}

@objc public protocol AutoCompleteTextFieldDelegate: UITextFieldDelegate {
    
    // Optional protocols
    
    // return NO to disallow editing. Defaults to YES.
    @objc optional func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    
    // became first responder
    @objc optional func textFieldDidBeginEditing(_ textField: UITextField)
    
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end. Defaults to YES.
    @objc optional func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
    
    // return NO to not change text. Defaults to YES.
    @objc optional func textField(_ textField: UITextField, changeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    
    // called when clear button pressed. return NO to ignore (no notifications)
    @objc optional func textFieldShouldClear(_ textField: UITextField) -> Bool
    
    // called when 'return' key pressed. return NO to ignore.
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
    
}

// MARK: - UITextFieldDelegate

extension AutoCompleteTextField: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, let delegateCall = delegate.textFieldShouldBeginEditing else { return true }
        
        return delegateCall(self)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let delegate = autoCompleteTextFieldDelegate, let delegateCall = delegate.textFieldDidBeginEditing else { return }
        
        delegateCall(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, let delegateCall = delegate.textFieldShouldEndEditing else { return true }
        
        return delegateCall(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let delegate = autoCompleteTextFieldDelegate, let delegateCall = delegate.textFieldDidEndEditing else { return }
        
        delegateCall(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let delegate = autoCompleteTextFieldDelegate, let delegateCall = delegate.textField(_:changeCharactersInRange:replacementString:) else { return true }
        
        return delegateCall(textField, range, string)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, let delegateCall = delegate.textFieldShouldClear else { return true }
        
        return delegateCall(self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, let delegateCall = delegate.textFieldShouldReturn else { return endEditing(true) }
        
        return delegateCall(self)
    }
}
