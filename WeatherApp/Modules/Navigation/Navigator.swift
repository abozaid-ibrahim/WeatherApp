//
//  Navigator.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

final class AppNavigator {
    static let shared = AppNavigator()
    private init() {}
    func set(window: UIWindow) {
        let navigationController = UINavigationController(rootViewController: Destination.weather.controller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
