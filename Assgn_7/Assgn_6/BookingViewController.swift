//
//  BookingViewController.swift
//  Assgn_6
//
//  Created by Sneha Sudhir Kawitkar on 3/2/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

class BookingViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    let context = getContext()
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var roomTypeField: UITextField!
    @IBOutlet weak var custIdField: UITextField!
    var comingFrom:Int = 0
    var pickerArray = ["","SINGLE OCCUPANCY","DOUBLE OCCUPANCY"]
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        custIdField.resignFirstResponder()
        return true
    }
    
    @IBAction func fromTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        comingFrom = 1
        datePickerView.minimumDate=NSDate() as Date
        datePickerView.addTarget(self, action: #selector(BookingViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func toTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.minimumDate=NSDate() as Date
        comingFrom = 2
        datePickerView.addTarget(self, action: #selector(BookingViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        if(comingFrom == 1){
            fromDateTextField.text = dateFormatter.string(from: sender.date)
        }else if(comingFrom == 2){
            toDateTextField.text = dateFormatter.string(from: sender.date)
        }
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        roomTypeField.inputView = pickerView
        self.hideKeyboardWhenTappedAround()
        self.custIdField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBOutlet weak var submitAction: UIBarButtonItem!
  
    @IBAction func submitAction(_ sender: UIBarButtonItem) {
        var fromDate: NSDate = NSDate()
        var toDate: NSDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        var strDate:String = ""
        
        strDate = fromDateTextField.text!
        if let date = dateFormatter.date(from: strDate){
            fromDate = date as NSDate
        }else{
            let alert = UIAlertController(title: "Alert", message: "FROM DATE NOT VALID!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        strDate = toDateTextField.text!
        if let date = dateFormatter.date(from: strDate){
            toDate = date as NSDate
        }else{
            let alert = UIAlertController(title: "Alert", message: "TO DATE NOT VALID!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        components.hour = 00
        components.minute = 00
        components.second = 00
        
        let today = gregorian.date(from: components)!
        if ((fromDate as Date) < today || (toDate as Date) < today){
            let alert = UIAlertController(title: "Alert", message: "DATES NOT IN SCOPE!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var components1 = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate as Date)
        
        components1.hour = 00
        components1.minute = 00
        components1.second = 00
        
        let fromDate1 = gregorian.date(from: components1)!
        
        var components2 = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: toDate as Date)
        
        components2.hour = 00
        components2.minute = 00
        components2.second = 00
        
        let toDate1 = gregorian.date(from: components2)!
        
        if (fromDate1 >= toDate1){
            let alert = UIAlertController(title: "Alert", message: "TO DATE CANNOT BE LESS THAN/EQUAL TO FROM DATE!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        strDate = custIdField.text!
        var customer: [Customer] = []
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
        request.predicate = NSPredicate(format: "custId = %@", strDate)
        request.returnsObjectsAsFaults = false
        do {
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
        
        strDate = roomTypeField.text!

        if(!(strDate=="SINGLE OCCUPANCY" || strDate=="DOUBLE OCCUPANCY")){
            let alert = UIAlertController(title: "Alert", message: "INVALID INPUT IN OCCUPANCY!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var rt: String = ""
        let rts:String = strDate
        switch rts {
        case "SINGLE OCCUPANCY":
            rt = "Single Occupancy"
        case "DOUBLE OCCUPANCY":
            rt = "Double Occupancy"
        default: break;
        }
        
        var flag:Bool = false
        var bookingName: String
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
        repeat{
            flag = false
            bookingName = "BOOK" + "".randomNumericString()
            request.predicate = NSPredicate(format: "bookingName = %@", bookingName)
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
        
        var booked:Bool = false
        var donebook:Bool = false
        
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "Room")
        var getRoomList: [Room] = []
        do{
           getRoomList = try context.fetch(request) as! [Room]
        }catch{
            print("Failed in Booking - Retreive Room List")
        }
        var getBookingList: [Booking] = []
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
        do{
            getBookingList = try context.fetch(request) as! [Booking]
        }catch{
            print("Failed in Booking - Retreive Room List")
        }
        
        for room in getRoomList{
            booked = false;
            if getBookingList.isEmpty{
                if room.roomType == rt {
                    let entity = NSEntityDescription.entity(forEntityName: "Booking", in: context)
                    let newBooking = NSManagedObject(entity: entity!, insertInto: context)
                    newBooking.setValue(bookingName, forKey: "bookingName")
                    newBooking.setValue(fromDate, forKey: "fromDate")
                    newBooking.setValue(toDate, forKey: "toDate")
                    newBooking.setValue(customer[0], forKey: "cust")
                    newBooking.setValue(room, forKey: "room")
                    do {
                        try context.save()
                        let alert = UIAlertController(title: "SUCCESS", message: "SUCCESSFULLY CREATED BOOKING WITH ID: "+bookingName, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        donebook = true
                        return
                    } catch {
                        print("Failed saving")
                    }
                }
            }
            else if(!getBookingList.isEmpty){
                for book in getBookingList{
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.timeStyle = DateFormatter.Style.none
                    dateFormatter1.dateStyle = DateFormatter.Style.short

                    let fromDate1 = dateFormatter1.string(from: fromDate as Date)
                    let toDate1 = dateFormatter1.string(from: toDate as Date)
                    let bfd = dateFormatter1.string(from: book.fromDate! as Date)
                    let btd = dateFormatter1.string(from: book.toDate! as Date)
                    if(bfd <= fromDate1 && btd >= toDate1 && (room.roomName==book.room?.roomName)){
                        booked = true;
                        break;
                    }
                }
                if(!booked && room.roomType == rt){
                    let entity = NSEntityDescription.entity(forEntityName: "Booking", in: context)
                    let newBooking = NSManagedObject(entity: entity!, insertInto: context)
                    newBooking.setValue(bookingName, forKey: "bookingName")
                    newBooking.setValue(fromDate, forKey: "fromDate")
                    newBooking.setValue(toDate, forKey: "toDate")
                    newBooking.setValue(customer[0], forKey: "cust")
                    newBooking.setValue(room, forKey: "room")
                    do {
                        try context.save()
                        let alert = UIAlertController(title: "SUCCESS", message: "SUCCESSFULLY CREATED BOOKING WITH ID: "+bookingName, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        donebook = true
                        return
                    } catch {
                        print("Failed saving")
                    }
                }
            }
        }
        if(!donebook){
            let alert = UIAlertController(title: "Alert", message: "NO AVAILABLE ROOMS, COULDN'T BOOK!!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}
