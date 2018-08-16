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
    
    let currentDate = Date()
    var calendarEventsDictionary = [Date: String]()
    var uid = ""
    
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
        setupCalendarEvents(uid: uid)
        print(uid)

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.hero.modalAnimationType = .slide(direction: .right)
        dismiss(animated: true, completion: nil)
        
    }
    
    func setupCalendarEvents(uid: String) {
        DataService.instance.getCalendarEvents(uid: uid) { (returnCalendarEventsDict) in
            self.calendarEventsDictionary = returnCalendarEventsDict
            print("before")
            print(self.calendarEventsDictionary)
            self.calendarView.reloadData()
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

