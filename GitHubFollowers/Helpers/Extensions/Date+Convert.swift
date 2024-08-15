//
//  Date+Convert.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 14/8/24.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
