//
//  UsedDates.swift
//  HorizontalCalendar
//
//  Created by Tony Ayoub on 1/28/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}


class UsedDates {
    static let shared = UsedDates()
    private let formatter:DateFormatter
    var displayedDate = Date()
    var displayedMondayDate = Date()
    var selectdDayOfWeek = 2 //default = Monday

    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        displayedDate = startDate
    }
    
    var startDate: Date {
        var startComponents = DateComponents()
        startComponents.calendar = Calendar.current
        startComponents.year = 2001
        startComponents.month = 1
        startComponents.day = 1
        startComponents.timeZone = TimeZone(abbreviation: "GMT")

        //1/1/2001 is Monday that is important
        let res = Calendar.current.date(from: startComponents) ?? Date()
        
        return res
        
    }
    
    var endDate: Date {
        var startComponents = DateComponents()
        startComponents.year = 2034
        startComponents.month = 12
        startComponents.day = 31
        //31/12/2034 is Sunday 
        return Calendar.current.date(from: startComponents) ?? Date()
    }
    
    func getIndexPathRowFromDate(date: Date) -> Int {
        let differenceOfDaysFromStartDate = date.interval(ofComponent: .day, fromDate: startDate)
        return differenceOfDaysFromStartDate
    }

    
    func getDayOfWeekLetterFromDayOfWeekNumber(dayOfWeekNumber: Int) -> String {
        switch dayOfWeekNumber {
        case 1:
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "T"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return "S"
        }
    }
    
    //give a specific date, return the date of Monday of the same week
    //this is used so that when Tuesday is selected for example and the user scrolls
    //always Tuesday is selected for any other week
    func getDateOfAnotherDayOfTheSameWeek(selectedDate: Date, requiredDayOfWeek: Int) -> Date {
        let cal = Calendar.current
        let inputDateDayOfWeek = cal.component(.weekday, from: selectedDate)
        if requiredDayOfWeek == inputDateDayOfWeek {
            return selectedDate
        }
        
        var usedDayOfWeek = requiredDayOfWeek
        if usedDayOfWeek == 1 || usedDayOfWeek == 2{ //Saturday or Sunday
            usedDayOfWeek += 7
            // if I'm in Wednesday and requiring date of Sunday for the week, the following subtraction will equal -3 because Sunday is 1 and Wed is 4. While I want the Sunday of the following week (want to add 4 days) so I add 7 to make it +4 instead of -3
            
            // if I'm in Sunday and asking for Sunday of the same week the first if statement returns the actual input date
        }
        
        let diff = requiredDayOfWeek - inputDateDayOfWeek
        //if input date is Wed and required date is date of Monday so the diff will equal - 2
        let result = addDaysToDate(daysToAdd: diff, toDate: selectedDate)
        return result
        
        
    }
    
    
    func addDaysToDate(daysToAdd: Int, toDate: Date) -> Date {
        var addedDays = DateComponents()
        addedDays.day = daysToAdd
        if let displayedMondayDate = Calendar.current.date(byAdding: addedDays, to: toDate) {
            return displayedMondayDate
        }
        else {
            return toDate
        }
    }
    func getDayOfWeekForDate(date: Date) -> Int {
        let cal = Calendar(identifier: .gregorian)
        let res = cal.component(.weekday, from: Date())
        return res

    }
    func setStartingDayOfDisplayedWeek() { //day of month of Monday
        let cal = Calendar.current
        let displayedWeekDay = cal.component(.weekday, from: displayedDate)
        
        var numberOfDaysToSubtract = displayedWeekDay - 2 // 2 is Monday
        if numberOfDaysToSubtract == -1 { //Sunday
            numberOfDaysToSubtract += 7 //will be 6
        }
        var addedComponents = DateComponents()
        addedComponents.day = numberOfDaysToSubtract * -1
        displayedMondayDate = cal.date(byAdding: addedComponents, to: displayedDate)!
    }
    
    func getDayFromIndexPath(indexPathRow: Int) -> Int {
        var addedComponents = DateComponents()
        addedComponents.day = indexPathRow
        let newDate = Calendar.current.date(byAdding: addedComponents, to: displayedMondayDate)
        return Calendar.current.component(.day, from: newDate!)
    }
        
    var displayedDateString: String {
        get {
            let longDateFormatter = DateFormatter()
            longDateFormatter.dateFormat = "EEEE, d MMM yyyy"
            return longDateFormatter.string(from: displayedDate)
            
        }
    }
    
}
