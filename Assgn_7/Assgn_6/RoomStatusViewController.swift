//
//  RoomStatusViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/25/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class RoomStatusViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    var roomsList: [Room] = []
    @IBOutlet weak var searchBar: UISearchBar!
    var fRoomList:[Room]? = []
    var selectedDate: Date = Date()
    var row: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fRoomList = roomsList
        tableView?.dataSource = self
        tableView?.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "roomDetailsSegue"){
            let controller = segue.destination as! RoomDetailsViewController
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                controller.room = roomsList[indexPath.row]
                controller.selectedDate = selectedDate
                controller.row = row
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")!
        cell.textLabel?.text = roomsList[indexPath.row].roomName
        cell.detailTextLabel?.text = roomsList[indexPath.row].roomType
        if let imageData = roomsList[indexPath.row].value(forKey: "roomImage") as? NSData {
            if let image = UIImage(data:imageData as Data) as? UIImage {
                cell.imageView?.image = image
            }
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if !searchText.isEmpty {
            roomsList = roomsList.filter { roomsList in
                return (roomsList.roomName?.lowercased().contains(searchText.lowercased()))!
            }
            
        } else {
            roomsList = fRoomList!
        }
        tableView.reloadData()
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
