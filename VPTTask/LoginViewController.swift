//
//  LoginViewController.swift
//  VPTTask
//
//  Created by iOS on 12/08/22.
//

import Foundation
import UIKit
import CoreData
class LoginViewController:UIViewController{
    @IBOutlet weak var email_field:UITextField!
    @IBOutlet weak var password_field:UITextField!
    @IBOutlet weak var lock_icon:UIButton!
    var email:String?
    var password:String?
    var RegList = NSArray()
    var username:String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        password_field.isSecureTextEntry = true

    }
    func getContext() -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
// MARK: – Database operation Methods
    func GetDataFromDB()
    {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        let predicate = NSPredicate(format: "email =%@", email_field.text!, "password =%@", password_field.text!)
        fetchRequest.predicate = predicate
        do {
            RegList = try context.fetch(fetchRequest) as NSArray
            if RegList.count > 0 {
                let objectentity = RegList.firstObject as! UserDetails
                if ((email_field.text == objectentity.email) && (password_field?.text == objectentity.password))
                   
                    {
                    if let name = objectentity.name {
                        username = name
                    }
                    UserDefaults.standard.set("Yes", forKey: "isLogin")
                    let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    homeVC.username = username ?? ""
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                    else
                    {
                        Constants.showAlert(tilte: "Warning.!", value: "UserName and Password does not match!!")
                    }
                }
            else{
                Constants.showAlert(tilte: "Warning.!", value: "Please Enter Valid User Details")
            }
            }catch let error as NSError{
                print("Could not Fetch, \(error)")
        }
    }
//MARK: - Password Secure Entry Action
    
    @IBAction func hide(_ sender: Any) {
     if(password_field.isSecureTextEntry == true)
     {
      password_field.isSecureTextEntry = false
        lock_icon.setImage(UIImage(named: "eye1"), for: .normal)
      }
      else
     {
        password_field.isSecureTextEntry = true
         lock_icon.setImage(UIImage(named: "eye"), for: .normal)
      }
    }
    
//MARK: - Login Button Action

    @IBAction func loginAction(_ sender:UIButton){
        email = email_field.text ?? ""
        password = password_field.text ?? ""
        if let email = email {
            if let password = password {
                if !Constants.isEmpty(text: email) && Constants.isValidEmail(email: email){
                    if !Constants.isEmpty(text: password) && Constants.isValidPassword(pass: password){
                        GetDataFromDB()
                    }
                    else{
                        Constants.showAlert(tilte: "Warning.!", value: "Please Enter Valid Password")
                    }
                }
                else{
                    Constants.showAlert(tilte: "Warning.!", value: "Please Enter Valid Email")
                }
            }
        }
       
    }
}
extension LoginViewController:UITextFieldDelegate{
// MARK: - Textfield Keyboard Return delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

