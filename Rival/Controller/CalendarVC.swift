//
//  GroupsVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-26.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import JTAppleCalendar
import SimpleAnimation

protocol CalendarVCDelegate: class {
    func onLogoutPressed()
}

class CalendarVC: UIViewController, SideMenuVCDelegate {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var missedBtn: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    
    var calendarEventsDictionary = [Date: String]()
    
    private var sideMenuVCNavigationController: UISideMenuNavigationController?
    weak var delegate: CalendarVCDelegate?
    
    let currentDate = Date()
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        setNameAndCalendar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.updateAllFeedMessage(forGroupKey: nil) { (isComplete) in
            if isComplete {
                print("updating feed complete.")
            } else {
                print("fail to update feed.")
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
    
    func getTimeStamp() -> String {
        formatter.dateFormat = "yyyy MM dd"
        let date = formatter.string(from: Date())
        return date
    }
    
    @IBAction func searchFriendPressed(_ sender: Any) {
        performSegue(withIdentifier: "CalendarToSearch", sender: self)
    }
    
    @IBAction func checkInTapped(_ sender: Any) {
        
        let uid = Auth.auth().currentUser?.uid
        DataService.instance.uploadDBUserCalendarEvent(uid: uid!, userData: [getTimeStamp(): "check in"])
        
        setNameAndCalendar()
        
        /* Button Animation */
        checkInBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.checkInBtn.transform = .identity},
                       completion: nil)
    }
    
    @IBAction func missedTapped(_ sender: Any) {
        
        let uid = Auth.auth().currentUser?.uid
        DataService.instance.uploadDBUserCalendarEvent(uid: uid!, userData: [getTimeStamp(): "missed"])
        setNameAndCalendar()
        
        /* Button Animation */
        missedBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.missedBtn.transform = .identity},
                       completion: nil)
    }
    
    //MARK: FIREBASE RETRIEVAL
    
    func setNameAndCalendar() {
        let uid = Auth.auth().currentUser?.uid
        
        DataService.instance.getCalendarEvents(uid: uid!) { (returnCalendarEventsDict) in
            self.calendarEventsDictionary = returnCalendarEventsDict
            self.calendarView.reloadData()
        }
        
        DataService.instance.getFullName(uid: uid!) { (returnName) in
            self.firstNameLabel.text = returnName.uppercased()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "SideMenuVCSegue" {
                if let sideMenuVCNavigationController = segue.destination as? UISideMenuNavigationController {
                    self.sideMenuVCNavigationController = sideMenuVCNavigationController
                    if let sideMenuVC = sideMenuVCNavigationController.viewControllers.first as? SideMenuVC {
                        sideMenuVC.delegate = self
                    }
                }
            }
            else if identifier == "CalendarToSearch" {
                if let destinationVC = segue.destination as? SearchFriendVC {
                    destinationVC.hero.isEnabled = true
                    destinationVC.hero.modalAnimationType = .slide(direction: .left)
                }
            }
        }
        
    }
    
    func onLogoutPressed() {
        sideMenuVCNavigationController?.dismiss(animated: true, completion: {
            self.delegate?.onLogoutPressed()
        })
    }
}

// MARK: - JTAppleCalendar Source and Delgate Extensions

extension CalendarVC: JTAppleCalendarViewDataSource {
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

extension CalendarVC: JTAppleCalendarViewDelegate {

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


