//
//  UICollectionView+Cell.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    /// WARNING: you must set the reuse identifier as same as the nib file name.
    func register<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.identifier, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }

    func updateFooter(size: CGSize) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.footerReferenceSize = size
        setCollectionViewLayout(layout, animated: true)
    }
}
