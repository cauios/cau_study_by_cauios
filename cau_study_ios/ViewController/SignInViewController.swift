//
//  SignInViewController.swift


import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var loginBgImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        self.view.insertSubview(loginBgImageView, at: 0)
        super.viewDidLoad()
        //emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.darkGray
        emailTextField.textColor = UIColor.darkGray
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])

        
        //passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.darkGray
        passwordTextField.textColor = UIColor.darkGray
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])

        signInButton.isEnabled = false
        handleTextField()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signInButton.isEnabled = false
                return
        }
        
        signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
    
    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            
        }, onError: { error in
            ProgressHUD.showError(error!)
        })
    }
    
    
}
