//
//  HomeViewController.swift
//  VPTTask
//
//  Created by iOS on 12/08/22.
//

import Foundation
import UIKit
import CoreData
class HomeViewController:UIViewController{
    @IBOutlet weak var product_tbl:UITableView!
    @IBOutlet weak var empty_view:UIView!
    @IBOutlet weak var add_btn:UIButton!
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var product_List:[NSManagedObject] = []
    let logout_btn = UIButton.init(type: .custom)
    var username = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        product_tbl.delegate = self
        product_tbl.dataSource = self
        getProduct()
        logoutButton()
        add_btn.addTarget(self, action: #selector(addProduct(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        getProduct()
    }
    
//MARK: - Floation Button Design for Customized
    func floatingButton(){
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: width-70, y: height-105, width: 50, height: 50)
        btn.setImage(UIImage(named: "Add"), for: .normal)
        btn.backgroundColor = UIColor(named: "ButtonColor")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.borderWidth = 1.0
        btn.addTarget(self,action: #selector(addProduct(_:)), for: .touchUpInside)
        view.addSubview(btn)
    }
//MARK: - Customize the Logout Button for Navigation Bar

    func logoutButton(){
        let customView = UIView(frame: CGRect(x: self.navigationController!.navigationBar.frame.size.width, y: 0, width: self.navigationController!.navigationBar.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height))
        logout_btn.setBackgroundImage(UIImage(named: "Logout"), for: .normal)
        logout_btn.frame = CGRect(x: customView.frame.size.width-60, y: 8, width: 30, height: 30)
        logout_btn.addTarget(self, action: #selector(logoutAction(button:)), for: .touchUpInside)
        customView.addSubview(logout_btn)
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
//MARK: - Logout Alert Action

    @objc func logoutAction(button:UIButton){
       
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Logout ?", preferredStyle: UIAlertController.Style.alert)
            alert.view.tintColor = UIColor(named: "ButtonColor")
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {
                action in
                self.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {
                action in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let rootViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                UserDefaults.standard.removeObject(forKey: "isLogin")
                navigationController.viewControllers = [rootViewController]
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navigationController
                UIApplication.shared.windows.first { $0.isKeyWindow }?.makeKeyAndVisible()
            }))
            self.present(alert, animated: false, completion: nil)
    }
    @objc func addProduct(_ sender:UIButton){
        let addProductVC = storyboard.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        navigationController?.pushViewController(addProductVC, animated: true)
    }
    func getContext()-> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
//MARK: - Get the Product from Local DB

    func getProduct() {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductList")
        do{
            product_List = try context.fetch(fetchRequest) as! [NSManagedObject]
            if product_List.isEmpty {
                empty_view.isHidden = false
            }
            else{
                empty_view.isHidden = true
                floatingButton()
            }
            product_tbl.reloadData()
        }catch let error {
            print(error.localizedDescription)
        }
    }
}
extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
//MARK: - TableView Datasource & Delegate Predefined Functions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = product_tbl.dequeueReusableCell(withIdentifier: "ProductTableCell", for: indexPath) as! ProductTableCell
        let item = product_List[indexPath.row]
        cell.category_name.text = item.value(forKey: "categoryname") as? String
        cell.category_type.text = item.value(forKey: "categorytype") as? String
        cell.category_amount.text = "₹ \(item.value(forKey: "amount") ?? "")"
        cell.tax_lbl.text = "Tax:- \(item.value(forKey: "tax") ?? "")"
        cell.category_img.image = UIImage(data: item.value(forKey: "image") as! Data)
        cell.category_img.layer.cornerRadius = 6
        cell.category_img.contentMode = .scaleAspectFill
        cell.totalAmount_lbl.text = "Total Amount: ₹ \(item.value(forKey: "totalamount") ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
class ProductTableCell:UITableViewCell{
    @IBOutlet var category_name:UILabel!
    @IBOutlet var category_type:UILabel!
    @IBOutlet var category_img:UIImageView!
    @IBOutlet var category_amount:UILabel!
    @IBOutlet var tax_lbl:UILabel!
    @IBOutlet var totalAmount_lbl:UILabel!
}
