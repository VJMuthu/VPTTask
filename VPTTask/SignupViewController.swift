//
//  SignupViewController.swift
//  VPTTask
//
//  Created by iOS on 12/08/22.
//

import Foundation
import UIKit
import CoreData
class SignupViewController:UIViewController{
    @IBOutlet weak var username_field:UITextField!
    @IBOutlet weak var email_field:UITextField!
    @IBOutlet weak var password_field:UITextField!
    @IBOutlet weak var confirm_password_field:UITextField!
    @IBOutlet weak var signin_lbl:UILabel!
    @IBOutlet weak var lock_icon:UIButton!
    @IBOutlet weak var lock_icon1:UIButton!
    
    let text = "Already have an Account.? SignIn"
    var username:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confirm_password_field.isSecureTextEntry = true
        password_field.isSecureTextEntry = true
    }
    func getContext() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    func SaveRecord() {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "UserDetails", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(username_field.text, forKey: "name")
        newUser.setValue(email_field.text, forKey: "email")
        newUser.setValue(password_field.text, forKey: "password")
        newUser.setValue(confirm_password_field.text, forKey: "confirmpassword")
       
        do{
            try context.save()
        }catch {
            print("Error : Failed")
        }
        
    }
//MARK: - Password Secure Entry Action
    @IBAction func hide(_ sender: UIButton) {
        if sender.tag == 0{
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
        else{
            if(confirm_password_field.isSecureTextEntry == true)
            {
                confirm_password_field.isSecureTextEntry = false
               lock_icon1.setImage(UIImage(named: "eye1"), for: .normal)
             }
             else
            {
                confirm_password_field.isSecureTextEntry = true
                lock_icon1.setImage(UIImage(named: "eye"), for: .normal)
             }

        }
    }
//MARK: - SignUp Button Action
    @IBAction func signUpAction(_ sender:UIButton){
        if !Constants.isEmpty(text: username_field.text ?? ""){
            if Constants.isNameValidation(name:username_field.text ?? ""){
                if !Constants.isEmpty(text: email_field.text ?? ""){
                    if Constants.isValidEmail(email: email_field.text ?? ""){
                        if !Constants.isEmpty(text: password_field.text ?? ""){
                            if Constants.isValidPassword(pass: password_field.text ?? ""){
                                if !Constants.isEmpty(text: confirm_password_field.text ?? ""){
                                    if Constants.isValidPassword(pass: confirm_password_field.text ?? ""){
                                        if password_field.text == confirm_password_field.text {
                                            UserDefaults.standard.set("Yes", forKey: "isLogin")
                                            if let name = username_field.text {
                                                username = name
                                            }
                                            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                            homeVC.username = username ?? ""
                                            navigationController?.pushViewController(homeVC, animated: true)
                                            SaveRecord()
                                        }
                                        else{
                                            Constants.showAlert(tilte: "Warning.!", value: "Password and Confirmpassword does'nt Match")
                                        }
                                    }
                                    else{
                                        Constants.showAlert(tilte: "Warning.!", value: "Please Enter Valid ConfirmPassword")
                                    }
                                }
                                else{
                                    Constants.showAlert(tilte: "Warning.!", value: "Please Enter Your ConfirmPassword")
                                }
                            }
                            else{
                                Constants.showAlert(tilte: "Warning.!", value: "Password Should Maintain 8 Letters with UpperCase & Spl Characters")
                            }
                        }
                        else{
                            Constants.showAlert(tilte: "Warning.!", value: "Please Enter Your Password")
                        }
                    }
                    else{
                        Constants.showAlert(tilte: "Warning.!", value: "Please Enter Valid Email")
                    }
                }
                else{
                    Constants.showAlert(tilte: "Warning.!", value: "Please Enter Your EmailID")
                }
            }
            else{
                Constants.showAlert(tilte: "Warning.!", value: "Please Enter Correct Name")
            }
        }
        else{
            Constants.showAlert(tilte: "Warning.!", value: "Please Enter Your Name")
        }
    }
    
    @IBAction func signInAction(_ sender:UIButton){
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(loginVC, animated: true)

    }
//MARK: - Signin tabgesture Userdefine Action
    func tabLabel(){
        signin_lbl.text = text
        signin_lbl.isUserInteractionEnabled = true
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "SignIn")
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: range)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "ButtonColor") as Any, range: range)
        signin_lbl.attributedText = underlineAttriString
        signin_lbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
//MARK: - tabgesture Action
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
    let termsRange = (text as NSString).range(of: "SignIn")
        if gesture.didTapAttributedTextInLabel(label: signin_lbl, inRange: termsRange) {
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController?.pushViewController(loginVC, animated: true)

        }
       
    }

}
extension SignupViewController:UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
        mutableStr.addAttributes([NSAttributedString.Key.font : label.font!], range: NSRange.init(location: 0, length: attributedText.length))
        // If the label have text alignment. Delete this code if label have a default (left) aligment. Possible to add the attribute in previous adding.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableStr)
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
 }
