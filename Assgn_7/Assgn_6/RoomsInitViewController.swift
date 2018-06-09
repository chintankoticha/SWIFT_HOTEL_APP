//
//  RoomsInitViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/24/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

class RoomsInitViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let datePicker = UIDatePicker()
    var selectedDate: Date = Date()
    var booked: [Room] = []
    var vacant: [Room] = []
    var list1: [String] = ["BOOKED ROOMS                                        -->" ,"VACANT ROOMS                                        -->"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list1.count
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var datePickerField: UIDatePicker!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //datePickerField.addTarget(self, action: Selector(("datePickerValueChanged:")), for: UIControlEvents.valueChanged)
        datePickerField.datePickerMode = UIDatePickerMode.date
        datePickerField.isHidden = true;
        tableView?.dataSource = self
        tableView?.delegate = self
        dateTextField.delegate = self
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        dateTextField.resignFirstResponder()
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")!
        cell.textLabel?.text = list1[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        datePickerField.isHidden = false
        datePickerField.addTarget(self, action: #selector(RoomsInitViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func textFieldEditing(_ sender: Any) {
        datePickerField.isHidden = false
        datePickerField.addTarget(self, action: #selector(RoomsInitViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "roomsListSegue"){
            if(dateTextField.text!.isEmpty){
                let alert = UIAlertController(title: "ALERT", message: "PLEASE ENTER A DATE FIRST!!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        
            var bflag:Bool = false
            let context = getContext()
            var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Room")
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
            if getRoomList.isEmpty{
                let alert = UIAlertController(title: "Alert", message: "NO ROOMS IN THE HOTEL!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            for room in getRoomList{
                bflag = false
                for book in getBookingList{
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.timeStyle = DateFormatter.Style.none
                    dateFormatter1.dateStyle = DateFormatter.Style.short
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat="MMM dd, yyyy"
                    selectedDate = formatter.date(from: (dateTextField?.text)!)!
                    
                    let fromDate1 = dateFormatter1.string(from: book.fromDate! as Date)
                    let toDate1 = dateFormatter1.string(from: book.toDate! as Date)
                    let today = dateFormatter1.string(from: selectedDate as Date)
                    
                    if(fromDate1 <= today && toDate1 >= today && (room.roomName==book.room?.roomName)){
                        bflag = true;
                        booked.append(room)
                        break;
                    }
                }
                
                if(!bflag){
                    vacant.append(room)
                }
            }
            
            if (segue.identifier == "roomsListSegue"){
                let controller = segue.destination as! RoomStatusViewController
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    if(indexPath.row == 0){
                        controller.roomsList = booked
                        controller.selectedDate = selectedDate
                        controller.row = 0
                    }else if(indexPath.row == 1){
                        controller.roomsList = vacant
                        controller.selectedDate = selectedDate
                        controller.row = 1
                    }
               }
            }
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
