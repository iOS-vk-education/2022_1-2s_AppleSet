//
//  AuthorizationViewController.swift
//  ITS
//
//  Created by New on 02.01.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class AuthorizationViewController:UIViewController{
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.textColor = .customTextColor
        emailField.placeholder = "Email Addres"
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        
        emailField.layer.borderWidth = 1
        emailField.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        emailField.layer.cornerRadius = 10
        
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.customBackgroundLayer.cgColor
        emailField.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        
        emailField.layer.shadowColor = UIColor.customButtonShadowColor.cgColor
        emailField.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        emailField.layer.shadowRadius = 9.0
        emailField.layer.shadowOpacity = 0.6
        emailField.layer.masksToBounds = false
        
        
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return emailField
    }()
    
    private let userName: UITextField = {
        let userName = UITextField()
        userName.textColor = .customTextColor
        userName.placeholder = "User name"
        userName.autocapitalizationType = .none
        userName.autocorrectionType = .no
        userName.layer.borderWidth = 1
        
        userName.layer.cornerRadius = 10
        
        userName.layer.borderWidth = 1
        userName.layer.borderColor = UIColor.customBackgroundLayer.cgColor
        userName.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        
        userName.layer.shadowColor = UIColor.customButtonShadowColor.cgColor
        userName.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        userName.layer.shadowRadius = 9.0
        userName.layer.shadowOpacity = 0.6
        userName.layer.masksToBounds = false
        
        userName.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        userName.leftViewMode = .always
        userName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return userName
    }()
    
    
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.textColor = .customTextColor
        passField.placeholder = "Password"
        passField.isSecureTextEntry = true
        passField.autocorrectionType = .no
        passField.layer.borderWidth = 1
        
        passField.layer.cornerRadius = 10
        
        passField.layer.borderWidth = 1
        passField.layer.borderColor = UIColor.customBackgroundLayer.cgColor
        passField.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        
        passField.layer.shadowColor = UIColor.customButtonShadowColor.cgColor
        passField.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        passField.layer.shadowRadius = 9.0
        passField.layer.shadowOpacity = 0.6
        passField.layer.masksToBounds = false
        
        passField.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return passField
    }()
    
    
    private let SinginButton: UIButton = {
    let button = UIButton()
        
    button.backgroundColor = .customBlue
    button.setTitleColor(.customTextColor, for: .normal)
    button.setTitle("Create account!", for: .normal)
    button.layer.cornerRadius = 20
        
    return button
}()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(userName)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(SinginButton)
        
        view.backgroundColor = .customBackgroundColor
        SinginButton.addTarget(self, action: #selector(SinginButtonTap), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        userName.frame = CGRect(x: 20, y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width-40, height: 50)
        
        emailField.frame = CGRect(x: 20, y: userName.frame.origin.y+userName.frame.size.height+10,
                                  width: view.frame.size.width-40, height: 50)
        
        passwordField.frame = CGRect(x: 20, y: emailField.frame.origin.y+emailField.frame.size.height+10,
                             width: view.frame.size.width-40, height: 50)
        
        SinginButton.frame = CGRect(x: 20, y:  passwordField.frame.origin.y+passwordField.frame.size.height+80,
                              width: view.frame.size.width-40, height: 50)
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        let BackButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(ExitButton))
        
        navigationItem.leftBarButtonItem = BackButton
        navigationController?.navigationBar.tintColor = .customDarkBlue
        title = "Authorization"
        
    }
    
    @objc private func ExitButton(){
        dismiss(animated: true)
    }
    
    @objc private func SinginButtonTap(){
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let username = userName.text, !username.isEmpty  else  {
            print("Missing field data")
            return
        }
            
          
        
        let alert = UIAlertController(title: "Create account",
                                      message: "Would you like to create an account",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
            Auth.auth().createUser(withEmail: email,
                                                password: password,
                                                completion: {[weak self]result, error in
                guard let strongSelf = self else{
                    
                    return
                }
                guard error == nil else {
                    if error?._code == AuthErrorCode.invalidEmail.rawValue{
                        self?.label.text = "Mail is in the wrong format"
                        self?.label.textColor = .red
                    }
                    else if error?._code == 17007 {
                        self?.label.text = "This email is already registered"
                        self?.label.textColor = .red
                        self?.SinginButton.isHidden = false
                    }
                    else if error?._code == AuthErrorCode.weakPassword.rawValue{
                        self?.label.text = "Password too weak"
                        self?.label.textColor = .red
                    }
                    
                    return
                }
                let db = Firestore.firestore()
                db.collection("users").document(email).setData(["username": username, "email": email, "uid":result!.user.uid, "avatarImageName": "avatar"])

                strongSelf.emailField.resignFirstResponder()
                strongSelf.passwordField.resignFirstResponder()
                
                
                let toMainController = RootTabBarViewController()
                
                let navigationController = UINavigationController(rootViewController: toMainController)
                
                let safeAreaInsets = toMainController.tabBar.safeAreaInsets
                let safeAreaCompensation = UIEdgeInsets(top: -100,
                                                        left: -safeAreaInsets.left,
                                                        bottom: -safeAreaInsets.bottom,
                                                        right: -safeAreaInsets.right)
                
                navigationController.additionalSafeAreaInsets = safeAreaCompensation
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true)
                
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in }))
        present(alert, animated: true)
    }
}
