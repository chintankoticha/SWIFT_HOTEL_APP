//
//  DeleteBookingViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/4/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

class DeleteBookingViewController: UIViewController,UITextFieldDelegate {
    let context = getContext()
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: UIBarButtonItem) {
        let bname = bookingNameField.text!
        var bcnt:Int = 0
        if(bname.isEmpty){
            let alert = UIAlertController(title: "Alert", message: "Please enter something!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        var status:Bool = false
        var getBookingList: [Booking] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
        do{
            getBookingList = try context.fetch(request) as! [Booking]
        }catch{
            print("Failed in Delete Booking - Retreive Booking List")
        }
        
        for b in getBookingList{
            if(b.bookingName == bname){
                bcnt += 1
            }
        }
        
        if(bcnt==0){
            let alert = UIAlertController(title: "Alert", message: "Booking Name Doesn't Exist!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
        fetchRequest.predicate = NSPredicate(format: "bookingName = %@", bname)
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object as! NSManagedObject)
                status = true
            }
        }
        
        if(status){
            let alert = UIAlertController(title: "Alert", message: "Successfully Deleted Booking!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    @IBOutlet weak var bookingNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.bookingNameField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        bookingNameField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
