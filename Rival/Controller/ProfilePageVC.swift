//
//  ProfilePageVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-13.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Hero
import Kingfisher
import Firebase

class ProfilePageVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var checkInsLbl: UILabel!
    @IBOutlet weak var missedLbl: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var followBtn: UIButton!
    
    let currentDate = Date()
    var calendarEventsDictionary = [Date: String]()
    var uid = ""
    var name = ""
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        setupCalendar()
        setupProfile(uid: uid)
        print(uid)

    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        let currentUserUid = Auth.auth().currentUser?.uid
        if followBtn.currentImage == UIImage(named: "follow.png") {
            DataService.instance.uploadUserFollowing(uid: currentUserUid!, userData: [uid: name])
            followBtn.setImage(UIImage(named: "following.png"), for: UIControlState.normal)
        } else if followBtn.currentImage == UIImage(named: "following.png") {
            DataService.instance.deleteUserFromFollowing(uid: uid)
            followBtn.setImage(UIImage(named: "follow.png"), for: UIControlState.normal)
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.hero.modalAnimationType = .slide(direction: .right)
        dismiss(animated: true, completion: nil)
        
    }
    
    func setupProfile(uid: String) {
        DataService.instance.getCalendarEvents(uid: uid) { (returnCalendarEventsDict) in
            self.calendarEventsDictionary = returnCalendarEventsDict
            self.calendarView.reloadData()
        }
        DataService.instance.getUserImage(uid: uid) { (returnUrl) in
            if returnUrl != "none" {
                let imageUrl = URL(string: returnUrl)
                self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2
                self.userImage.kf.setImage(with: imageUrl)
            }
        }
        DataService.instance.getFullName(uid: uid) { (returnName) in
            print(returnName)
            self.fullNameLbl.text = returnName.uppercased()
        }
        DataService.instance.checkIfFollowing(uid: uid) { (returnBool) in
            if returnBool {
                let image = UIImage(named: "following.png")
                self.followBtn.setImage(image, for: UIControlState.normal)
            } else {
                self.followBtn.setImage(UIImage(named: "follow.png"), for: UIControlState.normal)
            }
        }
    }

    func setupCalendar() {
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.allowsMultipleSelection = true
        
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date!)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date!)
    }
    
    // MARK: - CELL CONFIGURATION FUNCTIONS
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else {return}
        
        handleCellVisibility(cell: calendarCell, cellState: cellState)
        handleCellSelection(cell: calendarCell, cellState: cellState)
    }
    
    func handleCellVisibility(cell: CalendarCell, cellState: CellState) {
        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }
    
    func handleCellSelection(cell: CalendarCell, cellState: CellState) {
        
        cell.selectedView.backgroundColor = nil
        cell.selectedView.isHidden = true
        
        if let value = calendarEventsDictionary[cellState.date] {
            print(value)
            if value == "check in" {
                cell.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.selectedView.backgroundColor = #colorLiteral(red: 0.7414211631, green: 0.9360774159, blue: 0.5375202298, alpha: 0.6956068065)
                cell.selectedView.isHidden = false
            } else {
                cell.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.selectedView.backgroundColor = #colorLiteral(red: 0.7921568627, green: 0.1019607843, blue: 0.1019607843, alpha: 0.7)
                cell.selectedView.isHidden = false
            }
        } else {
            cell.dateLabel.textColor = #colorLiteral(red: 0.9843137255, green: 0.737254902, blue: 0.02745098039, alpha: 1)
            cell.selectedView.backgroundColor = nil
            cell.selectedView.isHidden = true
        }
    }

}

// MARK: - JTAppleCalendar Source and Delgate Extensions

extension ProfilePageVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        var startDateComponent = DateComponents()
        var endDateComponent = DateComponents()
        startDateComponent.year = -75
        endDateComponent.year = 75
        let startDate = Calendar.current.date(byAdding: startDateComponent, to: currentDate)
        let endDate = Calendar.current.date(byAdding: endDateComponent, to: currentDate)
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        
        return parameters
    }
}

extension ProfilePageVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let calendarCell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        calendarCell.dateLabel.text = cellState.text
        configureCell(cell: calendarCell, cellState: cellState)
        return calendarCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}

