//
//  RoomDetailsViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/25/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

class RoomDetailsViewController: UIViewController {

    var room: Room?
    var row:Int = 0
    var selectedDate: Date = Date()
    var booked: [Room] = []
    var vacant: [Room] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roomNameTxtField: UITextField!
    @IBOutlet weak var roomTypeTxtField: UITextField!
    @IBOutlet weak var roomPriceTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        roomNameTxtField.text = room?.roomName
        roomTypeTxtField.text = room?.roomType
        roomPriceTxtField.text = String((room?.price)!)
        if let imageData = room?.value(forKey: "roomImage") as? NSData {
            if let image = UIImage(data:imageData as Data) as? UIImage {
                imageView.image = image
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
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
        
        let controller = segue.destination as! RoomStatusViewController
        if(row == 0){
            controller.roomsList = booked
            controller.selectedDate = selectedDate
        }else if(row == 1){
            controller.roomsList = vacant
            controller.selectedDate = selectedDate
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
