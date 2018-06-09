//
//  RoomViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/2/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

class RoomViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let context = getContext()
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var roomTypeField: UITextField!
    var pickerArray = ["","SINGLE OCCUPANCY","DOUBLE OCCUPANCY"]
    
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func loadImageBtn(_ sender: Any) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        roomTypeField.inputView = pickerView
        self.hideKeyboardWhenTappedAround()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RoomViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.roomTypeField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.roomTypeField.resignFirstResponder()
        self.priceField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roomTypeField.text = pickerArray[row]
    }
    
    @IBAction func submitAction(_ sender: UIBarButtonItem) {
        var flag:Bool = false;
        var roomName: String
        
        let type = roomTypeField.text!
        if(type == ""){
            let alert = UIAlertController(title: "Alert", message: "Can't be empty, please select something!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var rType: String
        switch type{
        case "SINGLE OCCUPANCY":
            rType = "Single Occupancy"
            break;
        case "DOUBLE OCCUPANCY":
            rType = "Double Occupancy"
            break;
        default:
            let alert = UIAlertController(title: "Alert", message: "Please Select a Valid Input!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let pricetext = priceField.text!
        var price:Int = 0
        var flag1:Bool = false
        if let b = Int(pricetext){
            if(b<=0){
                flag1 = true
            }
            else if(b>Int.max){
                flag1 = true
            }
            else{
                price = b
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Price can contain only numbers!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(flag1){
            let alert = UIAlertController(title: "Alert", message: "Invalid Price Input!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let context = getContext()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Room")
        repeat{
            flag = false
            roomName = "ROOM" + "".randomNumericString()
            request.predicate = NSPredicate(format: "roomName = %@", roomName)
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                if result.count > 0{
                    flag = true;
                }
            }catch {
                print("Failed")
            }
        }while(flag)
        
        let entity = NSEntityDescription.entity(forEntityName: "Room", in: context)
        let newRoom = NSManagedObject(entity: entity!, insertInto: context)
        newRoom.setValue(roomName, forKey: "roomName")
        newRoom.setValue(rType, forKey: "roomType")
        newRoom.setValue(price, forKey: "price")
        var imgData:NSData
        if imageView?.image != nil {
            imgData = UIImagePNGRepresentation((imageView?.image!)!) as! NSData
            
        }
        else{
            imgData = UIImagePNGRepresentation(UIImage(named: "3")!) as! NSData
        }
        
        newRoom.setValue(imgData, forKey: "roomImage")
        do {
            try context.save()
            let alert = UIAlertController(title: "SUCCESS", message: "SUCCESSFULLY CREATED ROOM WITH NAME: "+roomName, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } catch {
            print("Failed saving")
        }
        return
    }
}
