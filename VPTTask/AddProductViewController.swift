//
//  AddProductViewController.swift
//  VPTTask
//
//  Created by iOS on 12/08/22.
//

import Foundation
import UIKit
import CoreData
class AddProductViewController:UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    @IBOutlet weak var category_name:UITextField!
    @IBOutlet weak var category_field:UITextField!
    @IBOutlet weak var picker_view: UIPickerView!
    @IBOutlet weak var amount_field:UITextField!
    @IBOutlet weak var tax_lbl:UILabel!
    @IBOutlet weak var total_amount_lbl:UILabel!
    @IBOutlet weak var dropdown_view:UIView!
    @IBOutlet weak var category_img:UIImageView!
    @IBOutlet weak var galleryView:UIView!
    @IBOutlet weak var cameraView:UIView!
    @IBOutlet weak var retakeView:UIView!
    @IBOutlet weak var cancelView:UIView!
    @IBOutlet weak var camera_Btn:UIButton!
    @IBOutlet weak var imagePick_btn:UIButton!
    

    let category_Type = ["Cloths","Health","Appliances"]
    let GST = ["16","12","18"]
    let imagePicker = UIImagePickerController()
    var image = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker_view.delegate = self
        picker_view.dataSource = self
        picker_view.isHidden = true
        dropdown_view.isHidden = true
        imagePicker.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false
    }
    func getContext() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
//MARK: - Save the product DB
    func saveProduct() {
        let entity = NSEntityDescription.entity(forEntityName: "ProductList", in: getContext())!
        let nsmanagedData = NSManagedObject(entity: entity, insertInto: getContext())
        nsmanagedData.setValue(category_name.text, forKey: "categoryname")
        nsmanagedData.setValue(category_field.text, forKey: "categorytype")
        nsmanagedData.setValue(amount_field.text, forKey: "amount")
        nsmanagedData.setValue(total_amount_lbl.text, forKey: "totalamount")
        nsmanagedData.setValue(tax_lbl.text, forKey: "tax")
        nsmanagedData.setValue(image, forKey: "image")
        do{
            try getContext().save()
        }catch {
            print("Error : Failed")
        }
    }
    @IBAction func CategoryImagePick(_ sender: UIButton)
    {
        imagePick_btn.tag = imagePick_btn.tag == 0 ? 1:0
        if imagePick_btn.tag == 0 {
            refreshAnimation()
        }
        else{
            UIView.animate(withDuration: 0.5, animations: { [self] in
                cameraView.center.y = retakeView.frame.minY + 5
                galleryView.center.y = retakeView.center.y
                cameraView.center.x =  retakeView.frame.maxX + 25
                galleryView.center.x =  retakeView.frame.maxX + 40
                cancelView.center.y = retakeView.frame.maxY - 5
                cancelView.center.x =  retakeView.frame.maxX + 25
            })
        }
    }
    //MARK: -- ImagePicker Open Camera
    @IBAction func CameraAction(_ sender:UIButton){
        openCamera()
        refreshAnimation()
        camera_Btn.tag = 0
        imagePick_btn.tag = 0
    }
    //MARK: -- ImagePicker Open Gallary
    @IBAction func GalleryAction(_ sender:UIButton){
        openGallary()
        refreshAnimation()
        camera_Btn.tag = 0
        imagePick_btn.tag = 0
    }
    @IBAction func CancelAction(_ sender:UIButton){
        refreshAnimation()
        camera_Btn.tag = 0
        imagePick_btn.tag = 0
    }
    func refreshAnimation(){
        UIView.animate(withDuration: 0.5, animations: { [self] in
            cameraView.center.y = retakeView.center.y
            galleryView.center.y = retakeView.center.y
            cameraView.center.x = retakeView.center.x
            galleryView.center.x = retakeView.center.x
            cancelView.center.y = retakeView.center.y
            cancelView.center.x = retakeView.center.x
        })
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            Constants.showAlert(tilte: "Warning", value: "You don't have camera")
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    //MARK: -- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            category_img.contentMode = .scaleToFill
            category_img.image = pickedImage
            category_img.layer.cornerRadius = 7.5
            image = pickedImage.pngData() ?? Data()
            imagePick_btn.isUserInteractionEnabled = false
        }
        picker.dismiss(animated: true, completion: nil)
    }
  


//MARK: - Submit Button Action

    @IBAction func submitAction(_ sender:UIButton){
        if !Constants.isEmpty(text: category_name.text ?? ""){
            if !Constants.isEmpty(text: category_field.text ?? ""){
                if !Constants.isEmpty(text: amount_field.text ?? ""){
                    if !Constants.isEmpty(text: tax_lbl.text ?? ""){
                        if !Constants.isEmpty(text: total_amount_lbl.text ?? ""){
                            if image != nil{
                                saveProduct()
                                navigationController?.popViewController(animated: true)
                            }
                            else{
                                Constants.showAlert(tilte: "Warning.!", value: "Please Upload Image")
                            }
                        }
                        else{
                            Constants.showAlert(tilte: "Warning.!", value: "Please Enter Category total Amount")
                        }
                    }
                    else{
                        Constants.showAlert(tilte: "Warning.!", value: "Please Enter Category Tax")
                    }
                }
                else{
                    Constants.showAlert(tilte: "Warning.!", value: "Please Enter Category Amount")
                }
            }
            else{
                Constants.showAlert(tilte: "Warning.!", value: "Please Select Category Type")
            }
        }
        else{
            Constants.showAlert(tilte: "Warning.!", value: "Please Enter Category Name")
        }
    }
    
//MARK: - Automatically Change the total Amount using the textfield delegate function

    func textFieldDidChangeSelection(_ textField: UITextField) {

        if textField == amount_field {
            let value = Float(amount_field.text ?? "") ?? 0
            let gst = Float(tax_lbl.text?.replacingOccurrences(of: " %", with: "", options: NSString.CompareOptions.literal, range: nil) ?? "") ?? 0
            let gstValue = ((value*gst)/100)
            let total_Amount = (value + gstValue).rounded()
            total_amount_lbl.text = "\(Int(total_Amount))"
        }
    }
    
//MARK: - Popup the Picker Action

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      
      if textField == category_field {
          picker_view.isHidden = false
          dropdown_view.isHidden = false

        return false
      }
       return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AddProductViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    //MARK: - Picker Datasource & Delegate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return category_Type.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category_Type[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        category_field.text = category_Type[row]
        tax_lbl.text = "\(GST[row]) %"
        picker_view.isHidden = true
        dropdown_view.isHidden = true

    }
}
