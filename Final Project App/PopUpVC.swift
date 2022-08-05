//
//  PopUpVC.swift
//  Final Project App
//
//  Created by Pablo Segovia on 7/29/22.
//

import UIKit

    // creates a popup after the tour is complete to tell the user that the tour is complete and gives them the link to the website
class PopUpVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }

    @IBAction func exitPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    

}
