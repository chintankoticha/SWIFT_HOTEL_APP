//
//  CustViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/2/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

extension String {
    
    ///For placeholders
    func randomAlphaNumericString(_ length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return string
    }
    
    func randomNumericString() -> String {
        let charactersString = "0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<3 {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return string
    }
}

class CustViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    let context = getContext()
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBAction func loadImageBtn(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    var idNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTextField.delegate = self
        self.idNumberTextField.delegate = self
        self.nameTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        imagePicker.delegate = self
        self.hideKeyboardWhenTappedAround()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        idNumber = "".randomAlphaNumericString(6)
        idNumberTextField.text = idNumber
    }
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var idNumberTextField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var cancelAction: UIButton!
    @IBOutlet weak var submitAction: UIBarButtonItem!
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction1(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: UIBarButtonItem) {

        let nametext = nameTextField.text!
        if (!containsOnlyLetters(nametext)){
            let alert = UIAlertController(title: "Alert", message: "Name can only contain alphabets!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let addrtext = addressTextField.text!
        if(addrtext.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "Alert", message: "Address Field cannot be blank!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let phonetext = phoneNumberTextField.text!
        if(phonetext.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "Alert", message: "Phone number cannot be blank!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var phoneNumber:Int
        if let number = Int(phonetext) {
            if(number < 0){
                let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if(number>Int.max){
                let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if(String(number).characters.count>10 || String(number).characters.count<10){
                let alert = UIAlertController(title: "Alert", message: "Invalid Phone Number!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            phoneNumber = number
        }else{
            let alert = UIAlertController(title: "Alert", message: "Phone Number can contain only numbers!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
        request.predicate = NSPredicate(format: "custId = %@", idNumberTextField.text!)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0
            {
                let alert = UIAlertController(title: "Alert", message: "CUSTOMER ALREADY EXISTS WITH SAME PHONE NUMBER/ID NUMBER!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        } catch {
            print("Failed")
        }
        request.predicate = NSPredicate(format: "phoneNumber = %@", String(phoneNumber))
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0
            {
                let alert = UIAlertController(title: "Alert", message: "CUSTOMER ALREADY EXISTS WITH SAME PHONE NUMBER/ID NUMBER!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        } catch {
            print("Failed")
        }
        
//        var numberflag:Bool = false;
//        for cust in getCList(){
//            if(phoneNumber == cust.phoneNumber || idNumberTextField.text == cust.idNumber){
//                numberflag = true;
//                break;
//            }
//        }
        
//        if(numberflag){
//            let alert = UIAlertController(title: "Alert", message: "CUSTOMER ALREADY EXISTS WITH SAME PHONE NUMBER/ID NUMBER!!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            numberflag = false
//            return
//        }
        let entity = NSEntityDescription.entity(forEntityName: "Customer", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(nametext, forKey: "custName")
        newUser.setValue(addrtext, forKey: "address")
        newUser.setValue(idNumber, forKey: "custId")
        newUser.setValue(phoneNumber, forKey: "phoneNumber")
        var imgData:NSData
        if imageView?.image != nil {
            imgData = UIImagePNGRepresentation((imageView?.image!)!) as! NSData
            
        }
        else{
            imgData = UIImagePNGRepresentation(UIImage(named: "1")!) as! NSData
        }
        
        newUser.setValue(imgData, forKey: "custImage")

        do {
            try context.save()
            let alert = UIAlertController(title: "SUCCESS", message: "SUCCESSFULLY CREATED CUSTOMER WITH ID: "+idNumber, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } catch {
            print("Failed saving")
        }
        
//        addCustomer(nametext,addrtext,idNumber,phoneNumber)
//        let alert = UIAlertController(title: "SUCCESS", message: "SUCCESSFULLY CREATED CUSTOMER WITH ID: "+idNumber, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//        return
    }

}
