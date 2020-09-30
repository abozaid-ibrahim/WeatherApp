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
    let intervalInSeconds = 24 * 60 * 60 / 5
    var isOfflineMode = true
    init(_ reachability: ReachabilityType = Reachability.shared) {
        self.reachability = reachability
    }

    var lastCallValid: Bool {
        guard let updateDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.apiLastUpdated.rawValue) as? Date else {
            return false
        }
        let timeDiff = Date() - updateDate
        return NSInteger(timeDiff) <= intervalInSeconds
    }

    var shouldLoadLocally: Bool {
        return isOfflineMode || lastCallValid || (!reachability.hasInternet())
    }

    func setLastUpdate(to date: Date = Date()) {
        UserDefaults.standard.set(date, forKey: UserDefaultsKeys.apiLastUpdated.rawValue)
        UserDefaults.standard.synchronize()
    }
}
