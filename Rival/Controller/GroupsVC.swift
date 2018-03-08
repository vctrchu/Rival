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

class GroupsVC: UIViewController, SideMenuVCDelegate {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    private var sideMenuVCNavigationController: UISideMenuNavigationController?
    weak var delegate: GroupsVCDelegate?
    
    let formatter = DateFormatter()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollToDate(Date())
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

extension GroupsVC: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate!,
                                                 numberOfRows: 1,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forFirstMonthOnly,
                                                 generateOutDates: .off,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: false)
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
    

}
    

    


