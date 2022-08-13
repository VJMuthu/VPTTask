//
//  Constants.swift
//  VPTTask
//
//  Created by iOS on 12/08/22.
//

import Foundation
import UIKit
class Constants:NSObject{
    //MARK: - Name Validation

    class func isNameValidation(name:String) -> Bool {
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: name)
    }
    //MARK: - Empty Value Check

    class func isEmpty(text: String) -> Bool {
      let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      return trimmed.isEmpty
    }
    //MARK: - Email Validation

    class func isValidEmail(email: String) -> Bool {
         let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

         let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailPred.evaluate(with: email)
     }
    //MARK: - Password Validation

    class func isValidPassword(pass:String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pass)
    }
    //MARK: - Show Alert

    class func showAlert(tilte:NSString, value:NSString){
        let alert = UIAlertController(title:tilte as String , message: value as String  , preferredStyle: UIAlertController.Style.alert)
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
