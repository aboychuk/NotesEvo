//
//  DateFormatter+Extensions.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/22/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /// Returns formatted date string, by default format value is "dd.MM.yy".
    public func dateString(_ date: Date, format: String = DateFormatType.ddMMyy.rawValue) -> String {
        self.dateFormat = format
        
        return self.string(from: date)
    }
    
    /// Returns formatted time string from given date, by default format value is "HH.mm".
    public func timeString(_  date: Date, format: String = DateFormatType.hhmm.rawValue) -> String {
        return self.dateString(date, format: format)
    }
    
    // MARK: - Format types
    
    public enum DateFormatType: String {
        case ddMMyy = "dd.MM.yy"
        case hhmm = "HH:mm"
    }
}
