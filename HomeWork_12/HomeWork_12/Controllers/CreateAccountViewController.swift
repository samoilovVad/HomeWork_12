//
//  SignUpViewController.swift
//  HomeWork_12
//
//  Created by Vadim Samoilov on 20.11.22.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    // MARK: - properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet var strongPasswordIndicatorsViews: [UIView]!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorConfirmPasswordLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var isValidEmail = false {
        didSet {
            updateContinueButtonState()
        }
    }
    private var isConfirmPassword = false {
        didSet {
            updateContinueButtonState()
        }
    }
    private var passwordStrength: PasswordStrength = .veryWeak {
        didSet {
            updateContinueButtonState()
        }
    }
    
    // MARK: - lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.contentInset.bottom = 0
    }
    
    // MARK: - actions
    
    @IBAction func emailTFAction(_ sender: UITextField) {
        isValidEmail = sender.text != nil && !(sender.text?.isEmpty ?? true) && VerificationService.isValidEmail(sender.text ?? "")
        emailErrorLabel.isHidden = isValidEmail
    }
    
    @IBAction func passwordTFAction(_ sender: UITextField) {
        if let pass = sender.text, !pass.isEmpty {
            passwordStrength = VerificationService.isValidPassword(pass: sender.text ?? "")
        } else {
            passwordStrength = .veryWeak
        }
        passwordErrorLabel.isHidden = passwordStrength != .veryWeak
        setupStrongPassIndicatorsViews()
    }
    
    
    @IBAction func confirmPasswordTFAction(_ sender: UITextField) {
        isConfirmPassword = sender.text != nil && !(sender.text?.isEmpty ?? true) && VerificationService.isPassCofirm(pass1: passwordTextField.text ?? "", pass2: sender.text ?? "")
        errorConfirmPasswordLabel.isHidden = isConfirmPassword
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
    }
    
    private func updateContinueButtonState() {
        continueButton.isEnabled = isValidEmail && isConfirmPassword && passwordStrength != .veryWeak
    }
    
    private func setupStrongPassIndicatorsViews() {
        strongPasswordIndicatorsViews.enumerated().forEach { index, view in
            if index <= (passwordStrength.rawValue - 1) {
                view.alpha = 1
            } else {
                view.alpha = 0.25
            }
        }
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
}
