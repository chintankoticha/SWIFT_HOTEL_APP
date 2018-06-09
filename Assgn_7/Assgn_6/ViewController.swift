//
//  ViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/2/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

func getContext() -> NSManagedObjectContext{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    return context
}

class ViewController: UIViewController {
    let context = getContext()
    @IBOutlet weak var AddCustBtn: UIButton!
    
    @IBAction func exitBtn(_ sender: UIButton) {
        exit(1)
    }
    
    func getResults() -> String{
        let todoEndpoint: String = "https://api.sandbox.amadeus.com/v1.2/hotels/search-airport?apikey=81weRGISisjQnVCSOmrBqN9tJq6ZARpV&location=BOS&check_in=2018-04-14&check_out=2018-04-16&number_of_results=10"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return "Error: cannot create URL"
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            var occ :String = ""
            var price : Int?
            var roomType : String = ""
            do {
                
                
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let hotels = json["results"] as? [[String: Any]] {
                    for hotel in hotels {
                        let roomName = hotel["property_name"] as? String
                        // roomNames.append(roomName)
                        
                        
                        if let rooms = hotel["rooms"] as? [[String: Any]] {
                            if let room = rooms[0] as? [String: Any] {
                                if let total_amount = room["total_amount"] as? [String: Any] {
                                    // roomPrice.append((total_amount["amount"] as? String)!)
                                    if let price1 = Double((total_amount["amount"] as? String)!){
                                        price = Int(price1)
                                    }
                                }
                                
                                if let room_type_info = room["room_type_info"] as? [String: Any] {
                                    if (room_type_info["number_of_beds"] as? String)=="1"{
                                        roomType = "Single Occupancy"
                                        occ = "S"
                                        
                                    }else{
                                        roomType = "Double Occupancy"
                                        occ = "D"
                                    }
                                    
                                }
                            }
                        }
                        
                        var imageName:String = occ + self.randomNumericString();
                        
                        self.createRoom(roomName!,roomType,price!,imageName)
                    }
                }
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        return "Done!"
    }
    
    func createRoom(_ roomName:String,_ roomChoice:String,_ price:Int,_ imageName:String){
        let entity = NSEntityDescription.entity(forEntityName: "Room", in: context)
        let newRoom = NSManagedObject(entity: entity!, insertInto: context)
        newRoom.setValue(roomChoice, forKey: "roomType")
        newRoom.setValue(price, forKey: "price")
        
        var imgData : NSData = UIImagePNGRepresentation(UIImage(named:imageName)!)! as NSData
        
        newRoom.setValue(imgData, forKey: "roomImage")
        newRoom.setValue(roomName , forKey: "roomName")
        do {
            try context.save()
            print("\(roomName) created successfully")
        } catch {
            print("Failed saving")
        }
    }
    
    func randomNumericString() -> String {
        let charactersString = "1234"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<1 {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.image = UIImage(named: "9-pool.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        getResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
