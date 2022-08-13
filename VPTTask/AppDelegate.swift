//
//  AppDelegate.swift
//  VPTTask
//
//  Created by iOS on 12/08/22.
//

import UIKit
import CoreData
import Security
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            UINavigationBar.appearance().standardAppearance = appearance
            appearance.backgroundColor = UIColor(named:"Navigation")
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().tintColor = UIColor.blue
        }
        else{
            let appearance = UINavigationBarAppearance()
            UINavigationBar.appearance().standardAppearance = appearance
            appearance.backgroundColor = UIColor(named:"Navigation")
            UINavigationBar.appearance().barTintColor = UIColor(named: "Navigation")
            UINavigationBar.appearance().tintColor = UIColor.blue

        }
        navigationScreen()
        return true
    }

    // MARK: UISceneSession Lifecycle



    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VPTTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func navigationScreen(){
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        let isfirst_time = KeychainService.loaddeviceID()
        if (isfirst_time != deviceId as NSString?) {
            KeychainService.savedeviceID(deviceID: deviceId! as NSString)
            let navigation = UINavigationController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigation.viewControllers = [welcomeVC]
            window?.rootViewController = navigation
            window?.makeKeyAndVisible()
        }
        else{
            let isLogin = UserDefaults.standard.object(forKey: "isLogin")
            if isLogin != nil {
                let navigation = UINavigationController()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                navigation.viewControllers = [loginVC]
                window?.rootViewController = navigation
                window?.makeKeyAndVisible()

            }
            else{
                let navigation = UINavigationController()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                navigation.viewControllers = [loginVC]
                window?.rootViewController = navigation
                window?.makeKeyAndVisible()
            }

        }
        
    }
}

extension UIViewController{
    var storyboard:UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

public class KeychainService: NSObject {
    // Constant Identifiers
    static let userAccount = "AuthenticatedUser"
    let accessGroup = "SecuritySerivice"
    static let passwordKey = "com.VPTTask"

    // Arguments for the keychain queries
    static let kSecClassValue = NSString(format: kSecClass)
    static let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
    static let kSecValueDataValue = NSString(format: kSecValueData)
    static let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
    static let kSecAttrServiceValue = NSString(format: kSecAttrService)
    static let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
    static let kSecReturnDataValue = NSString(format: kSecReturnData)
    static let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

 // Exposed methods to perform save and load queries.
         

        public class func savedeviceID(deviceID: NSString) {
            self.save(service: passwordKey as NSString, data: deviceID)
        }

        public class func loaddeviceID() -> NSString? {
            return self.load(service: passwordKey as NSString)
        }
        
    
  // Internal methods for querying the keychain.
         

        private class func save(service: NSString, data: NSString) {
            let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData

   // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

    // Delete any existing items
            SecItemDelete(keychainQuery as CFDictionary)

            // Add the new keychain item
            SecItemAdd(keychainQuery as CFDictionary, nil)
        }

        private class func load(service: NSString) -> NSString? {
            // Instantiate a new default keychain query
            // Tell the query to return a result
            // Limit our results to one item
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue!, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

            var dataTypeRef :AnyObject?

            // Search for the keychain items
            let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
            var contentsOfKeychain: NSString? = nil

            if status == errSecSuccess {
                if let retrievedData = dataTypeRef as? NSData {
                    contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
                }
            } else {
                print("Nothing was retrieved from the keychain. Status code \(status)")
            }

            return contentsOfKeychain
        }
    }

