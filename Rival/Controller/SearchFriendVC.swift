//
//  SearchFriendVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-14.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import SimpleAnimation
import Hero

class SearchFriendVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
        
    var fullNameArray = [String]()
    var userDictionary = [String: String]()
    var uidArray = [String]()
    var destinationUID = ""
    var destinationName = ""
    
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
        self.hero.modalAnimationType = .slide(direction: .right)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchProfileSegue" {
            if let destinationVC = segue.destination as? ProfilePageVC {
                destinationVC.hero.isEnabled = true
                destinationVC.hero.modalAnimationType = .slide(direction: .left)
                destinationVC.uid = destinationUID
                destinationVC.name = destinationName
            }
        }
    }
    
}

extension SearchFriendVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        
        cell.configureCell(profileImage: userDictionary[fullNameArray[indexPath.row]]!, fullname: fullNameArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destinationUID = uidArray[indexPath.row]
        destinationName = fullNameArray[indexPath.row]
        performSegue(withIdentifier: "SearchProfileSegue", sender: self)
    }
}

extension SearchFriendVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            userDictionary.removeAll()
            fullNameArray = []
            uidArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getFullNamePictureUID(forSearchQuery: searchBar.text!) { (returnUserDict, returnFullNameArray, returnUidArray) in
                self.userDictionary = returnUserDict
                self.fullNameArray = returnFullNameArray
                self.uidArray = returnUidArray
                self.tableView.reloadData()
            }
        }
    }
    
}
