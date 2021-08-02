//
//  secondDetailViewController.swift
//  Class Check
//
//  Created by Leon Yee on 6/24/21.
//  Copyright © 2021 Company. All rights reserved.
//

import UIKit
import JTAppleCalendar


class secondDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellReuseIdentifier = "tookClassCell1"
    let tookClassTable1 : UITableView = {
        let tookClassTable1 = UITableView()
        tookClassTable1.backgroundColor = UIColor(white: 1, alpha: 0.25)
        tookClassTable1.layer.borderColor = UIColor.white.cgColor
        tookClassTable1.layer.borderWidth = 1.0
        return tookClassTable1
    }()
    
    var temp = DetailViewController()
    public var classdates: [Any] = []
    var classdates2: [Date] = []
    var classdates3: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pinkishbackground")!)

        let weekdays : UILabel = {
            let weekdays = UILabel()
            weekdays.text = "   S       M       T       W       T       F       S"
            weekdays.textColor = UIColor.white
            weekdays.font = UIFont(name: "Noto Sans Myanmar", size: 19.75)
            weekdays.backgroundColor = UIColor(patternImage: UIImage(named: "pinkishbackground")!)
            weekdays.layer.borderColor = UIColor.white.cgColor
            weekdays.layer.borderWidth = 1
            return weekdays
        }()
        
        let helpLabel : UILabel = {
            let helpLabel = UILabel()
            helpLabel.text = "Class dates as a list:"
            helpLabel.textColor = UIColor.white
            helpLabel.font = UIFont(name: "Noto Sans Myanmar", size: 17)
            return helpLabel
        }()
        
        tookClassTable1.rowHeight = UITableView.automaticDimension
        tookClassTable1.estimatedRowHeight = 44
        tookClassTable1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tookClassTable1.delegate = self
        tookClassTable1.dataSource = self
        tookClassTable1.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        
        // CALENDAR STUFF
        
        let calendarView = JTAppleCalendarView(frame: CGRect.zero)
        calendarView.backgroundColor = .white
        calendarView.cellSize = 50
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor.white.cgColor
        calendarView.register(dateCell.self, forCellWithReuseIdentifier: "dateCell")
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                                     calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
                                     calendarView.widthAnchor.constraint(equalToConstant: 350)])

        view.addSubview(weekdays)
        weekdays.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([weekdays.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     weekdays.bottomAnchor.constraint(equalTo: calendarView.topAnchor),
                                     weekdays.widthAnchor.constraint(equalTo: calendarView.widthAnchor)])
        
        view.addSubview(tookClassTable1)
        tookClassTable1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tookClassTable1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     tookClassTable1.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 50),
                                     tookClassTable1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                                     tookClassTable1.widthAnchor.constraint(equalTo: calendarView.widthAnchor)])
        
        view.addSubview(helpLabel)
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([helpLabel.bottomAnchor.constraint(equalTo: tookClassTable1.topAnchor),
                                     helpLabel.leftAnchor.constraint(equalTo: calendarView.leftAnchor)])
        
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.allowsMultipleSelection = true
        
        calendarView.register(DateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeader.identifier)
        
        for i in classdates{
            classdates2.append(convertDateFormater(i))
            let s = String(describing: i)
            classdates3.append(s)
        }
        classdates2 = classdates2.uniqued()
        print(classdates2)
        
        calendarView.scrollToDate(Date())
        calendarView.selectDates(classdates2)
        
        
    }

    
    
    func convertDateFormater(_ date: Any) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date as! String) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components) ?? Date()
        return finalDate

    }
    
    
    // MARK: - TABLE VIEW FUNCS -
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classdates3.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (tookClassTable1.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!

        cell.textLabel?.text = classdates3[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundColor = UIColor(white: 1, alpha: 0.50)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}



// MARK: - JTAPPLECALENDAR -

extension secondDetailViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // The code here is the same as cellForItem function
        let cell = cell as! dateCell
        cell.dateLabel.text = cellState.text
        configureCell(view: cell, cellState: cellState)

    }
    
    
    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -6, to: today)!
        let endDate = Calendar.current.date(byAdding: .month, value: 3, to: today)!
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .off, hasStrictBoundaries: true)
    }
    
    
    public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! dateCell
        cell.dateLabel.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        let temp2 = format.string(from: date)
        let temp = format.string(from: Date())
        if temp2 == temp {
            cell.dateLabel.textColor = UIColor(patternImage: UIImage(named: "currentDay")!)
        }
        
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        /*
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yyyy"
        
        let temp2 = format.string(from: date)
        tookClassArray.append(temp2)
 */
        configureCell(view: cell, cellState: cellState)
        //print(cellState.date, cellState.day)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
 
    
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? dateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
        
    
    func handleCellTextColor(cell: dateCell, cellState: CellState) {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        let temp2 = format.string(from: cellState.date)
        let temp = format.string(from: Date())
        
        if temp == temp2 {
            cell.dateLabel.textColor = UIColor(patternImage: UIImage(named: "currentDay")!)
            cell.dateLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 20)
        } else if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.white
            cell.dateLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 20)
        } else {
            cell.dateLabel.textColor = UIColor.darkGray
            cell.dateLabel.font = UIFont(name: "Noto Sans Myanmar", size: 20)
        }
    }
    
    
    func handleCellSelected(cell: dateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  13
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM | yyyy"
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: DateHeader.identifier, for: indexPath) as! DateHeader
        header.dateHeader.text = formatter.string(from: range.start)
        header.dateHeader.font = UIFont(name: "Noto Sans Myanmar Bold", size: 30)
        header.dateHeader.textColor = UIColor.white
        header.backgroundColor = UIColor(patternImage: UIImage(named: "pinkishbackground")!)
        return header
    }
    
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return true
    }
    

}



extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
