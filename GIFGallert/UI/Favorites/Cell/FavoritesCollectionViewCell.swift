//
//  FavoritesCollectionViewCell.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

import UIKit

final class FavoritesCollectionViewCell: UICollectionViewCell {
    private var viewModel: FavoritesCollectionViewCellVM?
    // MARK: - UI Properties
    static let reuseIdentifier = "FavoritesTableviewCell"
    private let shadowView = UIView()
    private let containerView = UIView()
    private let gifImageView = UIImageView()
    private let titleLabel = UILabel(style: .body)
    private let removeButton = UIButton()
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup
    func configure(with viewModel: FavoritesCollectionViewCellVM) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        gifImageView.image = viewModel.image
    }
    
    func updateImage(using image: UIImage?) {
        gifImageView.image = image
    }
}

//MARK: - UI
extension FavoritesCollectionViewCell {
    private func setupUI() {
        setupHierarchy()
        setupShadowViewUI()
        setupContainerViewUI()
        setupLabelsUI()
        setupGIFImageViewUI()
        setupRemoveButtonUI()
    }
    private func setupHierarchy() {
        contentView.addSubviews(shadowView.useCodeLayout())
        
        shadowView.addSubviews(
            containerView.useCodeLayout(),
            gifImageView.useCodeLayout(),
            titleLabel.useCodeLayout(),
            removeButton.useCodeLayout()
        )
    }
    
    private func setupShadowViewUI() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.15
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.cornerRadius = 5
        shadowView.backgroundColor = .clear
    }

    
    private func setupContainerViewUI() {
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    private func setupLabelsUI() {
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupGIFImageViewUI() {
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.clipsToBounds = true
        gifImageView.layer.cornerRadius = 8
    }
    
    private func setupRemoveButtonUI() {
        removeButton.setImage(UIImage(systemName: "trash"), for: .normal)
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
    }
    
    @objc private func removeTapped() {
        viewModel?.onRemoveTapped?()
    }
}

//MARK: - Layout
extension FavoritesCollectionViewCell {
    private func setupLayout() {
        setupShahdowViewLayout()
        setupContainerViewLayout()
        setupGifImageLayout()
        setupRemoveButtonLayout()
        setupTitleLabelLayout()
    }
    
    private func setupShahdowViewLayout() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
    
    private func setupContainerViewLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
        ])
    }
    
    private func setupGifImageLayout() {
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            gifImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            gifImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            gifImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
        ])
    }
    
    private func setupTitleLabelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: removeButton.topAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupRemoveButtonLayout() {
        NSLayoutConstraint.activate([
            removeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            removeButton.widthAnchor.constraint(equalToConstant: 20),
            removeButton.heightAnchor.constraint(equalToConstant: 20),
            removeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
}

