//
//  AuthorizationViewController.swift
//  ITS
//
//  Created by New on 02.01.2023.
//

import UIKit
import Firebase

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
        emailField.textColor = .black
        emailField.placeholder = "Email Addres"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.backgroundColor = UIColor.white.cgColor
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return emailField
    }()
    
    private let userName: UITextField = {
        let userName = UITextField()
        userName.textColor = .black
        userName.placeholder = "User name"
        userName.layer.borderWidth = 1
        userName.autocapitalizationType = .none
        userName.layer.backgroundColor = UIColor.white.cgColor
        userName.leftViewMode = .always
        userName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return userName
    }()
    
    
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.textColor = .black
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.backgroundColor = UIColor.white.cgColor
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return passField
    }()
    
    
    private let SinginButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .customBlue
    button.setTitleColor(.black, for: .normal)
    button.setTitle("Create account!", for: .normal)
    return button
}()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(userName)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(SinginButton)
        
        view.backgroundColor = .white
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
        
        SinginButton.frame = CGRect(x: 20, y:  passwordField.frame.origin.y+passwordField.frame.size.height+30,
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
                

//                strongSelf.label.isHidden = true
//                strongSelf.button.isHidden = true
//                strongSelf.emailField.isHidden = true
//                strongSelf.passwordField.isHidden = true
//                strongSelf.Regbutton.isHidden = true
//                strongSelf.userName.isHidden = true
                

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
