//
//  LoginViewController.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    @IBAction func onLoginClick(_ sender: UIButton) {
        guard let username = loginField.text, let password = passwordField.text else {
            return
        }
        updateUI(loading: true)
        UdacityClient.login(username: username, password: password, completion: loginHandler(success:error:))
    }
    
    @IBAction func onSignUpClick(_ sender: UIButton) {
        UIApplication.shared.open(UdacityClient.Endpoints.signup.url, options: [:], completionHandler: nil)
    }
    
    func updateUI(loading: Bool) {
        if loading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        loginField.isEnabled = !loading
        passwordField.isEnabled = !loading
        loginButton.isEnabled = !loading
        signupButton.isEnabled = !loading
    }
    
    func loginHandler(success: Bool, error: Error?) {
        updateUI(loading: false)
        if success {
            performSegue(withIdentifier: "loginSegue", sender: nil)
            loginField.text = ""
            passwordField.text = ""
        } else {
            onLoginFailed(errorMessage: error?.localizedDescription ?? "Unknown error")
        }
    }
    
    func onLoginFailed(errorMessage: String) {
        let errorAlertController = UIAlertController(title: "Login failed", message: errorMessage, preferredStyle: .alert)
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
        show(errorAlertController, sender: nil)
    }
}
