//
//  BookingDetailsViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/28/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

class BookingDetailsViewController: UIViewController {

    var bookingList: [Booking] = []
    var booking: Booking?
    var today1: String = ""
    var cid: String = ""
    var searchBookings: [Booking] = []
    
    @IBOutlet weak var bookingNameField: UITextField!
    @IBOutlet weak var toDateField: UITextField!
    @IBOutlet weak var custIdField: UITextField!
    @IBOutlet weak var roomNameField: UITextField!
    @IBOutlet weak var fromDateField: UITextField!
    @IBOutlet weak var roomImageField: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM dd,yyyy"
        let myString_fromDate = formatter.string(from: booking?.fromDate as! Date)
        let myString_toDate = formatter.string(from: booking?.toDate as! Date)
        
        bookingNameField.text = booking?.bookingName
        fromDateField.text = myString_fromDate
        toDateField.text = myString_toDate
        roomNameField.text = booking?.room?.roomName
        custIdField.text = booking?.cust?.custId
        var room: Room = (booking?.room)!
        if let imageData = room.value(forKey: "roomImage") as? NSData {
            if let image = UIImage(data:imageData as Data) as? UIImage {
                roomImageField.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "backBtnSegue"){
            let context = getContext()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            let controller = segue.destination as! TestViewController
            
            var getBookingList: [Booking] = []
            var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
            do{
                getBookingList = try context.fetch(request) as! [Booking]
            }catch{
                print("Failed in Search Booking - Retreive Book List")
            }
            
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

            controller.bookingList = searchBookings
            controller.today1 = today1
            controller.cid = cid
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
