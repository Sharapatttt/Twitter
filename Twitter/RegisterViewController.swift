//
//  RegisterViewController.swift
//  Twitter
//
//  Created by Sharapat Azamat on 11/30/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RegisterViewController: UIViewController {

    var databaseRef = Database.database().reference()
    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var name_field: UITextField!
    @IBOutlet weak var surname_field: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func register_clicked(_ sender: UIButton) {
        let email = email_field.text
        let name = name_field.text
        let surname = surname_field.text
        let password = password_field.text
        if email != "" && password != "" && name != "" && surname != ""{
            indicator.startAnimating()
            Auth.auth().createUser(withEmail: email!, password: password!) { [weak self] (result, error) in
                self?.indicator.stopAnimating()
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                if error == nil{
                    self?.showMessage(title: "Success", message: "Pls verify your email")
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("email").setValue(email)
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("name").setValue(name)
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("surname").setValue(surname)
                    
                }else{
                    self?.showMessage(title: "Error", message: "Some problem occured")
                }
            }
        }
    }
   
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok",style: .default) { (UIAlertAction) in
            if title != "Error"{
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
    }

}
