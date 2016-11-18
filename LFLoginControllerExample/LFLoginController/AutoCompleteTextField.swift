//
//  AutoCompleteTextField.swift
//  Pods
//
//  Created by Neil Francis Hipona on 19/03/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation
import UIKit


open class AutoCompleteTextField: UITextField {
    
    /// AutoCompleteTextField data source
    open weak var autoCompleteTextFieldDataSource: AutoCompleteTextFieldDataSource?
    
    // AutoCompleteTextField data source accessible through IB
    @IBOutlet weak internal var dataSource: AnyObject! {
        didSet {
            autoCompleteTextFieldDataSource = dataSource as? AutoCompleteTextFieldDataSource
        }
    }
    
    /// AutoCompleteTextField delegate
    open weak var autoCompleteTextFieldDelegate: AutoCompleteTextFieldDelegate!
    
    // AutoCompleteTextField delegate accessible through IB
    weak open override var delegate: UITextFieldDelegate? {
        set (x) { autoCompleteTextFieldDelegate = x as? AutoCompleteTextFieldDelegate }
        get { return autoCompleteTextFieldDelegate }
    }
    
    fileprivate var autoCompleteLbl: UILabel!
    fileprivate var delimiter: CharacterSet?
    
    fileprivate var xOffsetCorrection: CGFloat {
        get {
            switch borderStyle {
            case .bezel, .roundedRect:
                return 6.0
            case .line:
                return 1.0
                
            default:
                return 0.0
            }
        }
    }
    
    fileprivate var yOffsetCorrection: CGFloat {
        get {
            switch borderStyle {
            case .line, .roundedRect:
                return 0.5
                
            default:
                return 0.0
            }
        }
    }
    
    /// Auto completion flag
    open var autoCompleteDisabled: Bool = false
    
    /// Case search
    open var ignoreCase: Bool = true
    
    /// Randomize suggestion flag. Default to ``false, will always use first found suggestion
    open var isRandomSuggestion: Bool = false
    
    /// Supported domain names
    static open let domainNames: [String] = {
        return SupportedDomainNames
    }()
    
    /// Text font settings
    override open var font: UIFont? {
        didSet { autoCompleteLbl.font = font }
    }
    
    override open var textColor: UIColor? {
        didSet {
            autoCompleteLbl.textColor = textColor?.withAlphaComponent(0.5)
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareAutoCompleteTextFieldLayers()
        setupTargetObserver()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareAutoCompleteTextFieldLayers()
        setupTargetObserver()
    }
    
    /// Initialize `AutoCompleteTextField` with `AutoCompleteTextFieldDataSource` and optional `AutoCompleteTextFieldDelegate`
    convenience public init(frame: CGRect, autoCompleteTextFieldDataSource dataSource: AutoCompleteTextFieldDataSource, autoCompleteTextFieldDelegate delegate: AutoCompleteTextFieldDelegate! = nil) {
        self.init(frame: frame)
        
        autoCompleteTextFieldDataSource = dataSource
        autoCompleteTextFieldDelegate = delegate
        
        prepareAutoCompleteTextFieldLayers()
        setupTargetObserver()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        prepareAutoCompleteTextFieldLayers()
        setupTargetObserver()
    }
    
    
    // MARK: - R
    override open func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        
        if !autoCompleteDisabled {
            autoCompleteLbl.isHidden = false
            
            if clearsOnBeginEditing {
                autoCompleteLbl.text = ""
            }
            
            processAutoCompleteEvent()
        }
        
        return becomeFirstResponder
    }
    
    override open func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        
        if !autoCompleteDisabled {
            autoCompleteLbl.isHidden = true
            
            processAutoCompleteEvent()
            commitAutocompleteText()
        }
        
        return resignFirstResponder
    }
    
    
    // MARK: - Private Funtions
    fileprivate func prepareAutoCompleteTextFieldLayers() {
        
        autoCompleteLbl = UILabel(frame: .zero)
        addSubview(autoCompleteLbl)
        
        autoCompleteLbl.font = font
        autoCompleteLbl.backgroundColor = .clear
        autoCompleteLbl.textColor = .lightGray
        autoCompleteLbl.lineBreakMode = .byClipping
        autoCompleteLbl.baselineAdjustment = .alignCenters
        autoCompleteLbl.isHidden = true
        
    }
    
    fileprivate func setupTargetObserver() {
        
        removeTarget(self, action: #selector(AutoCompleteTextField.autoCompleteTextFieldDidChanged(_:)), for: .editingChanged)
        addTarget(self, action: #selector(AutoCompleteTextField.autoCompleteTextFieldDidChanged(_:)), for: .editingChanged)
        
        super.delegate = self
    }
    
    fileprivate func performStringSuggestionsSearch(_ textToLookFor: String) -> String {
        
        // handle nil data source
        guard let autoCompleteTextFieldDataSource = autoCompleteTextFieldDataSource else { return processDataSource(SupportedDomainNames, textToLookFor: textToLookFor) }
        
        let dataSource = autoCompleteTextFieldDataSource.autoCompleteTextFieldDataSource(self)
        
        return processDataSource(dataSource, textToLookFor: textToLookFor)
    }
    
    fileprivate func processDataSource(_ dataSource: [String], textToLookFor: String) -> String {
        
        let stringFilter = ignoreCase ? textToLookFor.lowercased() : textToLookFor
        let suggestedStrings: [String] = dataSource.filter { (suggestedString) -> Bool in
            if ignoreCase {
                return suggestedString.lowercased().hasPrefix(stringFilter)
            }else{
                return suggestedString.hasPrefix(stringFilter)
            }
        }
        
        if suggestedStrings.isEmpty {
            return ""
        }

        if isRandomSuggestion {
            let maxSuggestionCount = suggestedStrings.count
            let randomIdx = arc4random_uniform(UInt32(maxSuggestionCount))
            let suggestedString = suggestedStrings[Int(randomIdx)]
            
            return performStringReplacement(suggestedString, stringFilter: stringFilter)
        }else{

            let suggestedString = suggestedStrings.sorted(by: { (elementOne, elementTwo) -> Bool in
                return elementOne.characters.count < elementTwo.characters.count
            }).first ?? ""
            return performStringReplacement(suggestedString, stringFilter: stringFilter)
        }
    }
    
    fileprivate func performStringReplacement(_ suggestedString: String, stringFilter: String) -> String {
        guard let filterRange = ignoreCase ? suggestedString.lowercased().range(of: stringFilter) : suggestedString.range(of: stringFilter) else { return "" }
        
        let finalString = suggestedString.replacingCharacters(in: filterRange, with: "")
        return finalString
    }
    
    fileprivate func autocompleteBoundingRect(_ autocompleteString: String) -> CGRect {
        
        // get bounds for whole text area
        let textRectBounds = self.textRect(forBounds: bounds)
        
        // get rect for actual text
        guard let textRange = textRange(from: beginningOfDocument, to: endOfDocument) else { return .zero }
        
        let textRect = firstRect(for: textRange).integral
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        
        let textAttributes: [String: AnyObject] = [NSFontAttributeName: font!, NSParagraphStyleAttributeName: paragraphStyle]
        
        let drawingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        let prefixTextRect = (text ?? ("" as NSString) as String).boundingRect(with: textRectBounds.size, options: drawingOptions, attributes: textAttributes, context: nil)
        
        let autoCompleteRectSize = CGSize(width: textRectBounds.width - prefixTextRect.width, height: textRectBounds.height)
        let autocompleteTextRect = (autocompleteString as NSString).boundingRect(with: autoCompleteRectSize, options: drawingOptions, attributes: textAttributes, context: nil)
        
        let xOrigin = textRect.maxX + xOffsetCorrection
        let autoCompleteLblFrame = autoCompleteLbl.frame
        let finalX = xOrigin + autocompleteTextRect.width
        let finalY = textRectBounds.minY + ((textRectBounds.height - autoCompleteLblFrame.height) / 2) - yOffsetCorrection
        
        if finalX >= textRectBounds.width {
            let autoCompleteRect = CGRect(x: textRectBounds.width, y: finalY, width: 0, height: autoCompleteLblFrame.height)
            
            return autoCompleteRect
            
        }else{
            let autoCompleteRect = CGRect(x: xOrigin, y: finalY, width: autocompleteTextRect.width, height: autoCompleteLblFrame.height)
            
            return autoCompleteRect
        }
    }
    
    fileprivate func processAutoCompleteEvent() {
        if autoCompleteDisabled {
            return
        }
        
        guard let textString = text else { return }
        
        if let delimiter = delimiter {
            guard let _ = textString.rangeOfCharacter(from: delimiter) else { return }
            
            let textComponents = textString.components(separatedBy: delimiter)
            
            if textComponents.count > 2 { return }
            
            guard let textToLookFor = textComponents.last else { return }
            
            let autocompleteString = performStringSuggestionsSearch(textToLookFor)
            updateAutocompleteLabel(autocompleteString)
        }else{
            let autocompleteString = performStringSuggestionsSearch(textString)
            updateAutocompleteLabel(autocompleteString)
        }
    }
    
    fileprivate func updateAutocompleteLabel(_ autocompleteString: String) {
        autoCompleteLbl.text = autocompleteString
        autoCompleteLbl.sizeToFit()
        autoCompleteLbl.frame = autocompleteBoundingRect(autocompleteString)
    }
    
    fileprivate func commitAutocompleteText() {
        guard let autocompleteString = autoCompleteLbl.text , !autocompleteString.isEmpty else { return }
        let originalInputString = text ?? ""
        
        autoCompleteLbl.text = ""
        text = originalInputString + autocompleteString
    }
    
    // MARK: - Internal Controls
    
    internal func autoCompleteButtonDidTapped(_ sender: UIButton) {
        endEditing(true)
        
        processAutoCompleteEvent()
        commitAutocompleteText()
    }
    
    internal func autoCompleteTextFieldDidChanged(_ textField: UITextField) {
        
        processAutoCompleteEvent()
    }
    
    
    // MARK: - Public Controls
    
    /// Set delimiter. Will perform search if delimiter is found
    open func setDelimiter(_ delimiterString: String) {
        delimiter = CharacterSet(charactersIn: delimiterString)
    }
    
    /// Show completion button with custom image
    open func showAutoCompleteButton(_ buttonImage: UIImage? = UIImage(named: "checked", in: Bundle(for: AutoCompleteTextField.self), compatibleWith: nil), autoCompleteButtonViewMode: AutoCompleteButtonViewMode) {
        
        var buttonFrameH: CGFloat = 0.0
        var buttonOriginY: CGFloat = 0.0
        
        if frame.height > defaultAutoCompleteButtonHeight {
            buttonFrameH = defaultAutoCompleteButtonHeight
            buttonOriginY = (frame.height - defaultAutoCompleteButtonHeight) / 2
        }else{
            buttonFrameH = frame.height
            buttonOriginY = 0
        }
        
        let autoCompleteButton = UIButton(frame: CGRect(x: 0, y: buttonOriginY, width: defaultAutoCompleteButtonWidth, height: buttonFrameH))
        autoCompleteButton.setImage(buttonImage, for: .normal)
        autoCompleteButton.addTarget(self, action: #selector(AutoCompleteTextField.autoCompleteButtonDidTapped(_:)), for: .touchUpInside)
        
        let containerFrame = CGRect(x: 0, y: 0, width: defaultAutoCompleteButtonWidth, height: frame.height)
        let autoCompleteButtonContainerView = UIView(frame: containerFrame)
        autoCompleteButtonContainerView.addSubview(autoCompleteButton)
        
        rightView = autoCompleteButtonContainerView
        rightViewMode = autoCompleteButtonViewMode
    }
    
    /// Force text completion event
    open func forceRefreshAutocompleteText() {
        
        processAutoCompleteEvent()
    }
    
}
