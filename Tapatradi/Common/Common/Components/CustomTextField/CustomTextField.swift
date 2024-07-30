//
//  TatTextField.swift
//  Common
//
//  Created by Aman Maharjan on 17/09/2021.
//

import UIKit

protocol CustomTextFieldDelegate {
    func customTextField(validate text: String) -> (isValid: Bool, validationResult: String)
}

@IBDesignable class CustomTextField: UIView {
    
    let viewModel = CustomTextFieldViewModel(countryFlagService: CountryFlagService.shared)
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var phoneCodeButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var validationStatusButton: UIButton!
    
    public var country: Country1? {
        didSet { viewModel.set(country: country) }
    }
    
    public var keyboardType = UIKeyboardType.default {
        didSet { textField.keyboardType = keyboardType }
    }
    
    public var text: String? {
        return textField.text
    }
    
    @IBInspectable public var hidePhoneCode: Bool = true {
        didSet {
            phoneCodeButton.isHidden = hidePhoneCode
            textField.setLeftPaddingPoints(textFieldLeftPadding)
        }
    }
    
    @IBInspectable public var maximumCharacters: Int = 0
    
    @IBInspectable public var placeholderText: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    @IBInspectable public var messageText: String? {
        get { return messageLabel.text }
        set { messageLabel.text = newValue }
    }
    
    @IBInspectable public var errorColor: UIColor? = UIColor.hexColor(0xC11B1B)
    
    private let animationDuration = TimeInterval(0.1)
    
    public var delegate: CustomTextFieldDelegate?
    
    private var hasError: Bool = false {
        didSet {
            if(hasError && !textField.text!.isEmpty) {
                let validationImage = ImageResource.validationCross.image
                validationStatusButton.setBackgroundImage(validationImage, for: .normal)
                textField.layer.borderColor = errorColor!.cgColor
                messageLabel.textColor = errorColor
            }
            else {
                let validationImage = ImageResource.validationCheck.image
                validationStatusButton.setBackgroundImage(validationImage, for: .normal)
                textField.layer.borderColor = textFieldBorderColor
                messageLabel.textColor = messageLabelTextColor
            }
        }
    }
    
    private var textFieldBorderColor: CGColor!
    private var placeholderLabelTextColor: UIColor!
    private var messageLabelTextColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        view = loadViewFromNib(nibName: "CustomTextField", frame: self.bounds)
        bindComponents()
        initCountryCodeButton()
        initTextField()
        initColors()
        validationStatusButton.setTitle("", for: .normal)
        addSubview(view)
    }
    
    private func bindComponents() {
        viewModel.phoneCode.bind { [weak self] phoneCode in
            guard let self = self else { return }
            self.phoneCodeButton.setTitle(phoneCode, for: .normal)
            self.phoneCodeButton.sizeToFit()
            self.textField.setLeftPaddingPoints(self.textFieldLeftPadding)
        }
        
        viewModel.countryFlag.bind { [weak self] countryFlag in
            self?.phoneCodeButton.setImage(countryFlag, for: .normal)
        }
    }
    
    private func initCountryCodeButton() {
        phoneCodeButton.setTitleColor(UIColor.black, for: .normal)
        phoneCodeButton.titleLabel?.font = FontResource.gtWalsheimProRegular.with(size: CGFloat(14))
    }
    
    private func initTextField() {
        textField.layer.borderColor = UIColor.hexColor(0xF1F2F2).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 6
        
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowRadius = 20
        textField.layer.shadowOffset = CGSize(width: 0, height: 4)
        textField.layer.shadowColor = UIColor.hexColor(0x893A12).cgColor
        
        textField.setLeftPaddingPoints(textFieldLeftPadding)
        textField.setRightPaddingPoints(34)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
    }
    
    private var textFieldLeftPadding: CGFloat {
        return hidePhoneCode ? 15 : phoneCodeButton.frame.width + 15
    }
    
    private func initColors() {
        textFieldBorderColor = textField.layer.borderColor
        messageLabelTextColor = messageLabel.textColor
    }
    
    override func layoutSubviews() {
        textField.setLeftPaddingPoints(textFieldLeftPadding)
    }
    
    override func prepareForInterfaceBuilder() {
        textField.placeholder = "Placeholder"
        messageLabel.text = "Message"
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.width, height: textField.frame.height + 50)
    }
    
    @IBAction func phoneCodeButton_TouchUpInside(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let controller = Route.selectCountry(model: CountryService.shared.asArray, delegate: self).controller
            self.parentViewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func validationStatusButton_TouchUpInside(_ sender: UIButton) {
        guard !textField.text!.isEmpty else { return }
        guard hasError else { return }
        textField.text = ""
        messageLabel.text = ""
        hasError = false
    }
}

extension CustomTextField: SelectCountryDelegate {
    
    func selectCountry(didSelect country: Country1) {
        self.country = country
    }
    
}

extension CustomTextField: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else { return }
        guard let result = delegate?.customTextField(validate: text) else { return }
        (hasError, messageText) = (!result.isValid, result.validationResult)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard maximumCharacters > 0 else { return true }
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maximumCharacters
    }
    
}
