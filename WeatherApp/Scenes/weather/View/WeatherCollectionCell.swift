//
//  WeatherCollectionCell.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class WeatherCollectionCell: UICollectionViewCell {
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var degreeLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    func setData(model: ForecastList) {
        dateLabel.text = model.formattedDate
        degreeLabel.text = model.weather?.first?.icon
        descriptionLabel.text = (model.weather?.first?.main)
    }
}
