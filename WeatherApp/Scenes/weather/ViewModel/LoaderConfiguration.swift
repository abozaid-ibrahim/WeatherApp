//
//  LoaderConfiguration.swift
//  WeatherApp
//
//  Created by abuzeid on 30.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

final class LoaderConfig {
    private let reachability: ReachabilityType
    let intervalInMinutes = 288
    var isOfflineMode = true

    init(_ reachability: ReachabilityType = Reachability.shared) {
        self.reachability = reachability
    }

    var isDataStillValid: Bool {
        guard let updateDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.apiLastUpdated.rawValue) as? Date,
            let oldDate = Calendar.current.date(byAdding: .minute, value: intervalInMinutes, to: updateDate) else {
            return false
        }
        return oldDate > Date()
    }

    var shouldLoadLocally: Bool {
        return isOfflineMode || isDataStillValid || (!reachability.hasInternet())
    }

    func setLastUpdate(to date: Date = Date()) {
        UserDefaults.standard.set(date, forKey: UserDefaultsKeys.apiLastUpdated.rawValue)
        UserDefaults.standard.synchronize()
    }
}

enum UserDefaultsKeys: String {
    case apiLastUpdated
}
