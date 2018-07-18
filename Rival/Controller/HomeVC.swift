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
    
    @IBAction func checkInTapped(_ sender: Any) {
        print("works")
    }
    
    @IBAction func missedTapped(_ sender: Any) {
        print("missed works")
    }
    
    private var sideMenuVCNavigationController: UISideMenuNavigationController?
    weak var delegate: GroupsVCDelegate?
    
    let formatter = DateFormatter()
    
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

extension HomeVC: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        var dateComponent = DateComponents()
        dateComponent.year = 1
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!)
                                            
        return parameters
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let calendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        sharedFunctionToConfigureCell(calendarCell: calendarCell, cellState: cellState, date: date)
        return calendarCell
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let calendarCell = cell as! CalendarCell
        sharedFunctionToConfigureCell(calendarCell: calendarCell, cellState: cellState, date: date)

    }

    func sharedFunctionToConfigureCell(calendarCell: CalendarCell, cellState: CellState, date: Date) {
        calendarCell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        
    }


}


    


