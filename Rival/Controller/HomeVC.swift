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

protocol GroupsVCDelegate: class {
    func onLogoutPressed()
}

class HomeVC: UIViewController, SideMenuVCDelegate {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    private var sideMenuVCNavigationController: UISideMenuNavigationController?
    weak var delegate: GroupsVCDelegate?
    
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
    }
    
    func setupCalendar() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
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
    
    /* CELL CONFIGURATION FUNCTIONS */
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else {return}
        
        handleCellVisibility(cell: calendarCell, cellState: cellState)
        handleCellSelection(cell: calendarCell, cellState: cellState)

    }
    
    //        func handleCellTextColor(cell: MyCell, cellState: CellState) {
    //            cell.textLabel.textColor = cellState.isSelected ? UIColor.red : UIColor.white
    //        }
    
    func handleCellVisibility(cell: CalendarCell, cellState: CellState) {
        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }
    
    func handleCellSelection(cell: CalendarCell, cellState: CellState) {
        cell.selectedView.isHidden = cellState.isSelected ? false : true
    }
    
    @IBAction func checkInTapped(_ sender: Any) {
        
        print("works")
    }
    
    @IBAction func missedTapped(_ sender: Any) {
        print("missed works")
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
        }
    }
    
    func onLogoutPressed() {
        sideMenuVCNavigationController?.dismiss(animated: true, completion: {
            self.delegate?.onLogoutPressed()
        })
    }
}

// MARK: - JTAppleCalendar code

extension HomeVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!)
        
        return parameters
    }
}

extension HomeVC: JTAppleCalendarViewDelegate {
    
//    func sharedFunctionToConfigureCell(calendarCell: CalendarCell, cellState: CellState, date: Date) {
//        calendarCell.dateLabel.text = cellState.text
//    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        //let calendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        //sharedFunctionToConfigureCell(calendarCell: calendarCell, cellState: cellState, date: date)
        let calendarCell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        self.calendar(calendar, willDisplay: calendarCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return calendarCell
    }
    

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let calendarCell = cell as? CalendarCell else {return}
        calendarCell.dateLabel.text = cellState.text
        configureCell(cell: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
//    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
////        if cellState.day == .sunday || cellState.day == .monday || cellState.day == .tuesday || cellState.day == .wednesday || cellState.day == .thursday || cellState.day == .friday || cellState.day == .saturday {
////            return false
////        }
//        return false
//    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    
    
//    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
//        return cellState.day == .monday || cellState.day == .sunday
//    }
    
}


    


