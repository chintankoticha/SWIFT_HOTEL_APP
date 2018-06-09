//
//  DisplayBookingViewController.swift
//  Assgn_6
//
//  Created by Sneha Sudhir Kawitkar on 3/3/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class DisplayBookingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayBookings = ""
        displayBookings = makedisplayBookingsString()
        bookingListField.text = displayBookings
    }

    @IBOutlet weak var bookingListField: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
