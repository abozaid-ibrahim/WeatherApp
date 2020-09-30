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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
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
        edgesForExtendedLayout = UIRectEdge.bottom

        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5)
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
            guard let self = self, !error.isEmpty else { return }
            DispatchQueue.main.async { self.show(error: error) }
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
        let fraction = CGFloat(0.8)
        return CGSize(width: collectionView.bounds.width * fraction, height: collectionView.bounds.height * fraction)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
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

extension UIViewController {
    func show(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
