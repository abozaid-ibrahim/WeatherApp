//
//  Date+TimeInterval.swift
//  WeatherApp
//
//  Created by abuzeid on 30.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension TimeInterval {
    var minutes: Int {

          let ti = NSInteger(self)


          let seconds = ti % 60
          let minutes = (ti / 60) % 60
          let hours = (ti / 3600)

          return hours*60*60 + minutes*60 + seconds
        
    }
}
