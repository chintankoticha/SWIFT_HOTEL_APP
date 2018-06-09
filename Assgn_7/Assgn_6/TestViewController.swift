//
//  TestViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/28/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import CoreData

class TestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var bookingList: [Booking] = []
    var today1: String = ""
    var cid: String = ""
    var fBookList:[Booking]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fBookList = bookingList
        tableView?.dataSource = self
        tableView?.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "bookingDetailsSegue"){
            let controller = segue.destination as! BookingDetailsViewController
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                controller.booking = bookingList[indexPath.row]
                controller.today1 = today1
                controller.cid = cid
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")!
        cell.textLabel?.text = bookingList[indexPath.row].bookingName
        cell.detailTextLabel?.text = bookingList[indexPath.row].room?.roomName
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if !searchText.isEmpty {
            bookingList = bookingList.filter { bookingList in
                return (bookingList.bookingName?.lowercased().contains(searchText.lowercased()))!
            }
        } else {
            bookingList = fBookList!
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let bookingId = (bookingList[indexPath.row]).value(forKey: "bookingName") as? String
            
            guard let appDelegate  = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
            let predicate = NSPredicate(format : "bookingName ==  %@",bookingId!)
            fetchRequest.predicate = predicate
            
            do {
                let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
                for item in items{
                    try managedObjectContext.delete(item)
                }
                try managedObjectContext.save()
            } catch {
                print("error deleting bookings")
            }
            
            bookingList.remove(at: indexPath.row)
            tableView.reloadData()
            
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
