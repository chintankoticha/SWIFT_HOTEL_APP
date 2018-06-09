//
//  CustomerDetailCellControllerViewController.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/24/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class CustomerDetailCellControllerViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var customer: Customer?
    var imgName: String?
    
        override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        custName.text = customer?.custName
        custAddress.text = customer?.address
        custPhone.text = String((customer?.phoneNumber)!)
        custImage?.image = UIImage(named: imgName!)
        if let imageData = customer?.value(forKey: "custImage") as? NSData {
            if let image = UIImage(data:imageData as Data) as? UIImage {
                custImage.image = image
            }
        }
    }

    @IBOutlet weak var custName: UITextField!
    @IBOutlet weak var custAddress: UITextField!
    @IBOutlet weak var custPhone: UITextField!
    @IBOutlet weak var custImage: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
