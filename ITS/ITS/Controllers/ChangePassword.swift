//
//  ChangePassword.swift
//  ITS
//
//  Created by New on 02.01.2023.
//

import UIKit
import Firebase

final class ChangePassword:UIViewController{
    private let label: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .white
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
    
    private let ResetPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBlue
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Change password", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ResetPasswordButton)
        view.addSubview(emailField)
        view.addSubview(label)
        
        view.backgroundColor = .white

        
        ResetPasswordButton.addTarget(self, action: #selector(ResetPasswordTapButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.frame = CGRect(x: 0, y: 120, width: view.frame.size.width, height: 80)
        
        emailField.frame = CGRect(x: 20, y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width-40, height: 50)
        
         ResetPasswordButton.frame = CGRect(x: 20, y: emailField.frame.origin.y+emailField.frame.size.height+20,
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
        title = "Change Password"
        
    }
    
    @objc private func ExitButton(){
        dismiss(animated: true)
    }
    
    @objc private func ResetPasswordTapButton(){
        guard let email = emailField.text, !email.isEmpty else  {
            return
        }
        
        let alert = UIAlertController(title: "Change password",
                                      message: "Check your email",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
            Auth.auth().sendPasswordReset(withEmail: email) {Error in
                if Error != nil {
                    self.label.text = "Wrong Email"
                    self.label.textColor = .red
                } else {
                    let toRegController = RegistrationController()
                    let navigationController = UINavigationController(rootViewController: toRegController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in }))
        present(alert, animated: true)
      
    }
}
