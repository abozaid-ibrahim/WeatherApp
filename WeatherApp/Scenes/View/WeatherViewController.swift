//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class WeatherViewController: UICollectionViewController {
    private let viewModel: WeatherViewModelType
    private var dataList: [ForecastList] { viewModel.dataList }
    private let offlineSwitch = UISwitch()

    init(with viewModel: WeatherViewModelType) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather app"
        view.backgroundColor = .white
        addOfflineSwitch()
        setupCollection()
        bindToViewModel()
        viewModel.loadData(offline: offlineSwitch.isOn)
    }

    @objc func offlineSelectorChanged(sender: UISwitch) {
        viewModel.loadData(offline: sender.isOn)
    }
}

// MARK: - Private

private extension WeatherViewController {
    func setupCollection() {
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        collectionView.register(WeatherCollectionCell.self)
        collectionView.register(ActivityIndicatorFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: ActivityIndicatorFooterView.id)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }

    func bindToViewModel() {
        viewModel.reloadData.subscribe { [weak self] reload in
            DispatchQueue.main.async {
                reload ? self?.collectionView.reloadData() : ()
            }
        }
    }

    func addOfflineSwitch() {
        offlineSwitch.addTarget(self, action: #selector(offlineSelectorChanged(sender:)), for: .valueChanged)
        let rightBarItem = UIBarButtonItem(customView: offlineSwitch)
        navigationItem.rightBarButtonItem = rightBarItem
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let padding = CGFloat(8)
        return CGSize(width: width - padding, height: collectionView.bounds.height - padding)
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionCell.identifier, for: indexPath) as! WeatherCollectionCell
        cell.setData(model: dataList[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: ActivityIndicatorFooterView.id,
                                                                   for: indexPath)

        default:
            #if DEBUG
                fatalError("Unexpected element kind")
            #endif
        }
    }
}
