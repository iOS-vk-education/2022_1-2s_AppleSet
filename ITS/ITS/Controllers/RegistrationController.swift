//
//  RegistrationController.swift
//  ITS
//
//  Created by New on 04.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrationController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "Log In"
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
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBlue
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Signin", for: .normal)
        return button
    }()
    
    
    private let SignOutbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBlue
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    private let Signbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBlue
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Start!", for: .normal)
        return button
    }()
    
    private let Regbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBlue
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Registrated", for: .normal)
        return button
    }()
    
        private let ShowCreateAccount: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Create account!", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(button)
        view.addSubview(ShowCreateAccount)
        view.addSubview(userName)
        view.addSubview(Regbutton)

        
        view.backgroundColor = .white
        
        
        userName.isHidden = true
        Regbutton.isHidden = true
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        ShowCreateAccount.addTarget(self, action: #selector(showCreateAccount), for: .touchUpInside)
        Regbutton.addTarget(self, action: #selector(RegistrationButton), for: .touchUpInside)
    
        if FirebaseAuth.Auth.auth().currentUser != nil{
            
//            let toMainController = RootTabBarViewController()
//            present(toMainController, animated: true)
//
            label.isHidden = true
            emailField.isHidden = true
            passwordField.isHidden = true
            button.isHidden = true
            ShowCreateAccount.isHidden = true
            
            view.addSubview(SignOutbutton)
            SignOutbutton.frame = CGRect(x: 20, y: 210, width: view.frame.size.width-40, height: 52)
            SignOutbutton.addTarget(self, action: #selector(LogOutTapped), for: .touchUpInside)
            
            view.addSubview(Signbutton)
            Signbutton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width-40, height: 52)
            Signbutton.addTarget(self, action: #selector(LogTapped), for: .touchUpInside)

            
            
        }
    }
    

    
    @objc func LogTapped(){
        let toMainController = RootTabBarViewController()
        
        let navigationController = UINavigationController(rootViewController: toMainController)
        
        let safeAreaInsets = toMainController.tabBar.safeAreaInsets
        let safeAreaCompensation = UIEdgeInsets(top: -100,
                                                left: -safeAreaInsets.left,
                                                bottom: -safeAreaInsets.bottom,
                                                right: -safeAreaInsets.right)
        
        navigationController.additionalSafeAreaInsets = safeAreaCompensation
        
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
//        present(toMainController, animated: true)
    }
    
    @objc func LogOutTapped(){
        do {
            try FirebaseAuth.Auth.auth().signOut()
            label.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            button.isHidden = false
            Signbutton.isHidden = true
            ShowCreateAccount.isHidden = false

            SignOutbutton.removeFromSuperview()
        }
        catch {
            print("An error occurred")
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
         
        userName.frame = CGRect(x: 20, y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width-40, height: 50)
        
        emailField.frame = CGRect(x: 20, y: userName.frame.origin.y+userName.frame.size.height+10,
                                  width: view.frame.size.width-40, height: 50)
        
        passwordField.frame = CGRect(x: 20, y: emailField.frame.origin.y+emailField.frame.size.height+10,
                             width: view.frame.size.width-40, height: 50)
        
        button.frame = CGRect(x: 20, y:  passwordField.frame.origin.y+passwordField.frame.size.height+30,
                              width: view.frame.size.width-40, height: 50)
        
        Regbutton.frame = CGRect(x: 20, y:  passwordField.frame.origin.y+passwordField.frame.size.height+30,
                              width: view.frame.size.width-40, height: 50)
        
        ShowCreateAccount.frame = CGRect(x: 20, y:  button.frame.origin.y+passwordField.frame.size.height+30,
                                    width: view.frame.size.width-40, height: 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil{
            emailField.becomeFirstResponder()
        }
       
    }
    
    @objc private func didTapButton(){
//        print("tap tap tap!!!")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else  {
            
            return
        }
        
        Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else{

                return
            }
            guard error == nil else {
                self?.label.text = "Log in"
                self?.label.textColor = .black
                if error?._code == AuthErrorCode.wrongPassword.rawValue{
                    self?.label.text = "Wrong Password"
                    self?.label.textColor = .red
                } else if error?._code == AuthErrorCode.invalidEmail.rawValue{
                    self?.label.text = "Mail is in the wrong format"
                    self?.label.textColor = .red
                } else {
                    self?.label.text = "Wrong username or password"
                    self?.label.textColor = .red
                }
//
                return
            }
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
        
    }
    
    
    
    @objc private func showCreateAccount(){ //должна быть кнопкой, пока отсылается на кнопку входа
        ShowCreateAccount.isHidden = true
        userName.isHidden = false
        button.isHidden = true
        Regbutton.isHidden = false
        
        
    }
    
    @objc private func RegistrationButton(){
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
                    else if error?._code == AuthErrorCode.weakPassword.rawValue{
                        self?.label.text = "Password too weak"
                        self?.label.textColor = .red
                    }
                    
                    return
                }
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["username": username, "email": email, "uid":result!.user.uid])
                
                print("singed in!!!!")
                strongSelf.label.isHidden = true
                strongSelf.button.isHidden = true
                strongSelf.emailField.isHidden = true
                strongSelf.passwordField.isHidden = true
                strongSelf.Regbutton.isHidden = true
                strongSelf.userName.isHidden = true
                

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

