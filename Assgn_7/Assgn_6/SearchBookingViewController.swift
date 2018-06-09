//
//  SearchBookingViewController.swift
//  Assgn_6
//
//  Created by Sneha Sudhir Kawitkar on 3/3/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

class SearchBookingViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var custIdField: UITextField!
    @IBOutlet weak var searchTextView: UITextView!
    var searchBookings: [Booking] = []
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.custIdField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        custIdField.resignFirstResponder()
        return true
    }
    
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action:
    #selector(SearchBookingViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateField.text = dateFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "submitBtnSegue"){
            let context = getContext()
            
            var getBookingList: [Booking] = []
            var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
            do{
                getBookingList = try context.fetch(request) as! [Booking]
            }catch{
                print("Failed in Search Booking - Retreive Book List")
            }
            
            if(getBookingList.isEmpty){
                let alert = UIAlertController(title: "SUCCESS", message: "NO BOOKINGS YET!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            let today1 = dateField.text!
            let cid = custIdField.text!
            
            if(today1.isEmpty && cid.isEmpty){
                let alert = UIAlertController(title: "Alert", message: "PLEASE ENTER SOMETHING!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }else if(!today1.isEmpty && !cid.isEmpty){
                var searchDate:NSDate = NSDate()
                
                if let date = dateFormatter.date(from: today1){
                    searchDate = date as NSDate
                }else{
                    let alert = UIAlertController(title: "Alert", message: "FROM DATE NOT VALID!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                var customer: [Customer] = []
                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
                request.predicate = NSPredicate(format: "custId = %@", cid)
                request.returnsObjectsAsFaults = false
                do{
                    customer = try context.fetch(request) as! [Customer]
                    if customer.count == 0
                    {
                        let alert = UIAlertController(title: "Alert", message: "INVALID CUSTOMER ID!!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                } catch {
                    print("Failed")
                }
                
                var roomcnt:Int = 0
                for book in getBookingList{
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.timeStyle = DateFormatter.Style.none
                    dateFormatter1.dateStyle = DateFormatter.Style.short
                    
                    let fd = book.fromDate! as Date
                    let td = book.toDate! as Date
                    let sd = searchDate as Date
                    
                    if((fd...td).contains(sd)  && (book.cust?.custId == cid )){
                        roomcnt += 1
                        searchBookings.append(book)
                    }
                }
                if(roomcnt==0){
                    let alert = UIAlertController(title: "Alert", message: "NO ROOMS BOOKED FOR THIS CUSTOMER FOR GIVEN DATE!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            if(!today1.isEmpty && cid.isEmpty){
                var searchDate:NSDate = NSDate()
                
                if let date = dateFormatter.date(from: today1){
                    searchDate = date as NSDate
                }else{
                    let alert = UIAlertController(title: "Alert", message: "FROM DATE NOT VALID!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                var roomcnt:Int = 0
                for book in getBookingList{
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.timeStyle = DateFormatter.Style.none
                    dateFormatter1.dateStyle = DateFormatter.Style.short
                    
                    let fd = book.fromDate! as Date
                    let td = book.toDate! as Date
                    let sd = searchDate as Date
                    
                    if((fd...td).contains(sd)){
                        roomcnt += 1
                        searchBookings.append(book)
                    }
                }
                if(roomcnt==0){
                    let alert = UIAlertController(title: "Alert", message: "NO ROOMS BOOKED FOR THIS CUSTOMER FOR GIVEN DATE!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            if(today1.isEmpty && !cid.isEmpty){
                
                var customer: [Customer] = []
                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
                request.predicate = NSPredicate(format: "custId = %@", cid)
                request.returnsObjectsAsFaults = false
                do{
                    customer = try context.fetch(request) as! [Customer]
                    if customer.count == 0
                    {
                        let alert = UIAlertController(title: "Alert", message: "INVALID CUSTOMER ID!!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                } catch {
                    print("Failed")
                }
                
                var roomcnt:Int = 0
                for book in getBookingList{
                    if(book.cust?.custId == cid){
                        roomcnt += 1
                        searchBookings.append(book)
                    }
                }
                if(roomcnt==0){
                    let alert = UIAlertController(title: "Alert", message: "NO ROOMS BOOKED FOR THIS CUSTOMER!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            let controller = segue.destination as! TestViewController
            controller.bookingList = searchBookings
            controller.today1 = today1
            controller.cid = cid
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
