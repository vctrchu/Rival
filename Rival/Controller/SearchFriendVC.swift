//
//  SearchFriendVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-14.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class SearchFriendVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = #imageLiteral(resourceName: "searchBg")
        searchBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.168627451, alpha: 1)
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
