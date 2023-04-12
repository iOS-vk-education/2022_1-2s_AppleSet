//
//  RegistrationController.swift
//  ITS
//
//  Created by New on 04.12.2022.
//

import UIKit
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
        emailField.autocapitalizationType = .none
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
        userName.textColor = .black
        userName.placeholder = "User name"
        userName.autocapitalizationType = .none
        
        userName.layer.borderWidth = 1
        userName.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        
        userName.leftViewMode = .always
        userName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return userName
    }()
    
    
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.textColor = .black
        passField.placeholder = "Password"
        passField.isSecureTextEntry = true
        
        passField.layer.borderWidth = 1
        passField.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        passField.layer.cornerRadius = 10
        
        passField.layer.borderWidth = 1
        passField.layer.borderColor = UIColor.customBackgroundLayer.cgColor
        passField.layer.backgroundColor = UIColor.customBackgroundLayer.cgColor
        
        passField.layer.shadowColor = UIColor.customButtonShadowColor.cgColor
        passField.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        passField.layer.shadowRadius = 9.0
        passField.layer.shadowOpacity = 0.6
        passField.layer.masksToBounds = false
        
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return passField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .customBlue
        button.setTitleColor(.customTextColor, for: .normal)
        button.setTitle("Sign In", for: .normal)
        return button
    }()

    
        private let ShowCreateAccount: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBackgroundColor
        button.setTitleColor(.customTextColor, for: .normal)
        button.setTitle("Create account!", for: .normal)
        return button
    }()
    
    private let SinginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBlue
        button.setTitleColor(.customTextColor, for: .normal)
        button.setTitle("Return to Authorization", for: .normal)
        return button
    }()
    
    private let ResetPassword: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBackgroundColor
        button.setTitleColor(.customTextColor, for: .normal)
        button.setTitle("Fogot password?", for: .normal)
        return button
    }()
    
    private let ResetPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBlue
        button.setTitleColor(.customTextColor, for: .normal)
        button.setTitle("Change password", for: .normal)
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
        view.addSubview(SinginButton)
        view.addSubview(ResetPassword)
        view.addSubview(ResetPasswordButton)

        
        view.backgroundColor = .customBackgroundColor
        
        
        userName.isHidden = true
        SinginButton.isHidden = true
        ResetPasswordButton.isHidden = true
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        ShowCreateAccount.addTarget(self, action: #selector(showCreateAccount), for: .touchUpInside)
        
        SinginButton.addTarget(self, action: #selector(SinginButtonTap), for: .touchUpInside)
        ResetPassword.addTarget(self, action: #selector(ResetPasswordTap), for: .touchUpInside)
       

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
       
        ResetPasswordButton.frame = CGRect(x: 20, y: emailField.frame.origin.y+emailField.frame.size.height+10,
                                           width: view.frame.size.width-40, height: 50)
        
        ShowCreateAccount.frame = CGRect(x: 20, y:  button.frame.origin.y+passwordField.frame.size.height+30,
                                    width: view.frame.size.width-40, height: 50)
        
        ResetPassword.frame = CGRect(x: 20, y:  ShowCreateAccount.frame.origin.y+passwordField.frame.size.height+180,
                                    width: view.frame.size.width-40, height: 50)
      
        SinginButton.frame = CGRect(x: 20, y:  button.frame.origin.y+ShowCreateAccount.frame.size.height+10,
                                    width: view.frame.size.width-40, height: 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil{
            emailField.becomeFirstResponder()
        }
       
    }
    
    @objc private func ResetPasswordTap(){
        let toChangeController = ChangePassword()
        let navigationController = UINavigationController(rootViewController: toChangeController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    
    @objc private func didTapButton(){
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else  {
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else{

                return
            }
            guard error == nil else {
                self?.label.text = "Log in"
                self?.label.textColor = .customTextColor
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
        
        let toCreateController = AuthorizationViewController()
        let navigationController = UINavigationController(rootViewController: toCreateController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
                               
    @objc private func SinginButtonTap(){ // обратный переход на вход если почта существует
        userName.isHidden = true
        button.isHidden = false
        SinginButton.isHidden = true
        label.text = "Log In"
        label.textColor = .customTextColor
        passwordField.text = ""
    }

}

