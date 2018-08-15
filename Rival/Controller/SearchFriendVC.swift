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
    
    @IBOutlet weak var tableView: UITableView!
    
    var fullNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = #imageLiteral(resourceName: "searchBg")
        searchBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.168627451, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SearchFriendVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        
        let profileImage = UIImage(named: "defaultProfilePic")
        cell.configureCell(profileImage: profileImage!, fullname: fullNameArray[indexPath.row])
        
        return cell
    }
}

extension SearchFriendVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            fullNameArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getFullName(forSearchQuery: searchBar.text!) { (returnFullNameArray) in
                self.fullNameArray = returnFullNameArray
                self.tableView.reloadData()
            }
        }
    }
    
}
