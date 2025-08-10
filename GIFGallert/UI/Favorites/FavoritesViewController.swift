//
//  FavoritesViewController.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

import UIKit

final class FavoritesViewController: BaseViewController {
    private let viewModel: FavoritesViewModel
    // MARK: - UI Properties
    private let countImage = UIImageView()
    private let countLabel = UILabel(style: .title)
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    //MARK: - Life Cycle
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        showLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
        fetchData()
    }
    
}
//MARK: - Binding & Logic
extension FavoritesViewController {
    private func bindViewModel() {
        viewModel.onLoadData = { [weak self] in
            guard let self else { return }
            bindCellViewModel()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                collectionView.reloadData()
                countLabel.text = "\(self.viewModel.favoritesCellViewModels.count)"
                hideLoader()
            }
        }
        
        viewModel.favoriteseDataError = { [weak self] errorText in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                hideLoader()
                showAlert(title: "Error", text: errorText)
            }
        }
    }
    
    private func fetchData() {
        self.viewModel.fetchFavorites()
    }
    
    private func bindCellViewModel() {
        for (index, viewModel) in viewModel.favoritesCellViewModels.enumerated() {
            viewModel.onGifLoaded = { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: index, section: 0)
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? FavoritesCollectionViewCell {
                        cell.updateImage(using: viewModel.image)
                    }
                }
            }
            viewModel.loadImage()
        }
    }
}
//MARK: - CollectionView Delegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.goToDetails(cellVM: viewModel.favoritesCellViewModels[indexPath.row])
    }
}

//MARK: - CollectionView Datasource
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favoritesCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.reuseIdentifier, for: indexPath) as? FavoritesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let cellViewModel = viewModel.favoritesCellViewModels[indexPath.item]
        cell.configure(with: cellViewModel)
        return cell
    }
}

//MARK: - CollectionView Layout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 * 2
        let availableWidth = collectionView.frame.width - padding
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

//MARK: - UI
extension FavoritesViewController {
    private func setupUI() {
        title = "Favorites"
        setupCountviewUI()
        setupCollectionViewUI()
        setupHierarchy()
    }
    
    private func setupHierarchy() {
        view.addSubviews(collectionView.useCodeLayout(), countImage.useCodeLayout(), countLabel.useCodeLayout())
    }
    
    private func setupCountviewUI() {
        countImage.image = UIImage(systemName: "star.fill")
        countLabel.textAlignment = .center
        countLabel.font = .systemFont(ofSize: 27, weight: .bold)
        countLabel.text = "0"
    }
    
    private func setupCollectionViewUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesCollectionViewCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
    }
}
//MARK: - Layout
extension FavoritesViewController {
    private func setupLayout() {
        setupCountViewLayout()
        setupCollectionViewLayout()
    }
    
    private func setupCountViewLayout() {
        NSLayoutConstraint.activate([
            countImage.heightAnchor.constraint(equalToConstant: 40),
            countImage.widthAnchor.constraint(equalToConstant: 40),
            countImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            countImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            countLabel.topAnchor.constraint(equalTo: countImage.topAnchor),
            countLabel.leadingAnchor.constraint(equalTo: countImage.trailingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: countImage.bottomAnchor)
        ])
    }
    
    private func setupCollectionViewLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: countImage.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
