//
//  RoomDetailViewController.swift
//  Assgn_6
//
//  Created by Sneha Sudhir Kawitkar on 3/2/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class RoomDetailViewController: UIViewController {

    @IBOutlet weak var cancelAction: UIBarButtonItem!
    @IBOutlet weak var roomDetailsField: UITextView!
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        roomdetails = ""
        roomdetails = makeRoomDetailsString()
        roomDetailsField.text = roomdetails
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
