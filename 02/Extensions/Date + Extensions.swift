//
//  Date + Extensions.swift
//  02
//
//  Created by Марина on 08.03.2023.
//

import Foundation


extension Date {
    
    func getWeekdayNumber() -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self) //self -Date
//        print(weekday)
        return weekday
    }
    
    func localDate() -> Date { //+3 часа?
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        let localDate = Calendar.current.date(byAdding: .second,value: Int(timeZoneOffset)  ,to: self) ?? Date()
        return localDate
    }
    
    func getWeekArray() -> [[String]] {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "EEEEEE" //Day of week. Short name.
        let calendar = Calendar.current
        
        var weekArray : [[String]] = [[], []]
        
        for index in -6...0 {
            let date = calendar.date(byAdding: .day, value: index, to: self) ?? Date()
//            print("date - \(date)")
            let day = calendar.component(.day, from: date)
//            print("day - \(day)")
            weekArray[1].append("\(day)")
            let weekday = formatter.string(from: date)
            weekArray[0].append(weekday)
        }
//        print(weekArray)
        return weekArray
    }
    
    func offsetDay(day: Int) -> Date {//сдвигаемся на n дней
        let offsetDate = Calendar.current.date(byAdding: .day, value: -day, to: self) ?? Date()
        return offsetDate
    }
    
    func offsetMonth(month: Int) -> Date {//сдвигаемся на n месяцев
        let offsetMonth = Calendar.current.date(byAdding: .month, value: -month, to: self) ?? Date()
        return offsetMonth
    }
    
    func startEndDate() -> (start: Date, end: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let calendar = Calendar.current
//        let day = calendar.component(.day, from: self)
//        let month = calendar.component(.month, from: self)
//        let year = calendar.component(.year, from: self)
        
//        let dateStart = formatter.date(from: "\(year)/\(month)/\(day)") ?? Date()
        
        let stringDate = formatter.string(from: self)
//        print("string - \(stringDate)")
        let totalData = formatter.date(from: stringDate) ?? Date()
//        print("total - \(totalData)")
        
        let local = totalData.localDate()
        let dateEnd: Date = {
            let components = DateComponents(day: 1)
            return calendar.date(byAdding: components, to: local) ?? Date()
        }()
   
        return (local, dateEnd)
    }
    
    func ddMMyyyyFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: self)
        return date
    }
}
