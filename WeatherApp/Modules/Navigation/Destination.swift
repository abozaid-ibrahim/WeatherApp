//
//  Destination.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

enum Destination {
    case weather
    var controller: UIViewController {
        return WeatherViewController()
    }
}
