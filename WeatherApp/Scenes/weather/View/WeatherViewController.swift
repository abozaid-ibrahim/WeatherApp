//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by abuzeid on 01.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    private let viewModel: WeatherViewModelType
    private let offlineSwitch = UISwitch()
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    private var dataList: [ForecastList] { viewModel.dataList }

    init(with viewModel: WeatherViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "WeatherViewController", bundle: Bundle(for: WeatherViewController.self))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather app"
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
        collectionView.register(WeatherCollectionCell.self)
        collectionView.register(ActivityIndicatorFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: ActivityIndicatorFooterView.id)
    }

    func bindToViewModel() {
        viewModel.reloadData.subscribe { [weak self] reload in
            DispatchQueue.main.async { if reload { self?.collectionView.reloadData() } }
        }
        viewModel.isLoading.subscribe { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let size: CGSize = isLoading ? self.collectionView.bounds.size : .zero
                self.collectionView.updateFooter(size: size)
            }
        }
        viewModel.error.subscribe { [weak self] error in
            guard let self = self, let msg = error else { return }
            DispatchQueue.main.async { self.show(error: msg) }
        }
        viewModel.city.subscribe { [weak self] value in
            DispatchQueue.main.async { self?.cityLabel.text = value }
        }
    }

    func addOfflineSwitch() {
        offlineSwitch.addTarget(self, action: #selector(offlineSelectorChanged(sender:)), for: .valueChanged)
        let rightBarItem = UIBarButtonItem(customView: offlineSwitch)
        navigationItem.rightBarButtonItem = rightBarItem
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    var cellSize: CGSize {
        let fraction = CGFloat(0.85)
        return CGSize(width: collectionView.bounds.width * fraction, height: collectionView.bounds.height * fraction)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection != nil else { return }
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionCell.identifier, for: indexPath) as! WeatherCollectionCell
        cell.setData(model: dataList[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
