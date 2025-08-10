//
//  DetailsViewController.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

import UIKit

final class DetailsViewController: BaseViewController {
    private let viewModel: DetailsViewModel
    
    // MARK: - UI Properties
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let mainImageView = UIImageView()
    private let titleLabel = UILabel(style: .title)
    private let usernameLabel = UILabel(style: .body)
    private let typeLabel = UILabel(style: .body)
    private let slugLabel = UILabel(style: .body)
    private let urlLabel = UILabel(style: .body)
    
    private let favouriteButton = UIButton().useCodeLayout()
    private let favStackView = UIStackView().useCodeLayout()
    
    // MARK: - Init
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
}

// MARK: - Binding
private extension DetailsViewController {
    func bindViewModel() {
        titleLabel.text = viewModel.title
        usernameLabel.text = viewModel.username
        typeLabel.text = "\(viewModel.type)"
        slugLabel.text = "\(viewModel.slug)"
        urlLabel.text = "\(viewModel.url)"
        
        if let imageURL = URL(string: viewModel.imageURL) {
            loadImage(from: imageURL)
        }
        
        viewModel.updateToFavorite = { [weak self] isFavorite in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateFavoriteButton(isFavorite: isFavorite)
            }
        }
    }
    
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                self?.mainImageView.image = image
            }
        }
    }
}

// MARK: - UI Setup
private extension DetailsViewController {
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = viewModel.title
        
        setupScrollView()
        setupContentStack()
        setupImageView()
        setupLabels()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupContentStack() {
        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    func setupImageView() {
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.layer.cornerRadius = 12
        mainImageView.clipsToBounds = true
        mainImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        contentStack.addArrangedSubview(mainImageView)
    }
    
    func setupLabels() {
        let detailsCard = makeCardView(with: [
            makeSection(title: "Username", valueLabel: usernameLabel),
            makeSection(title: "Type", valueLabel: typeLabel),
            makeSection(title: "Slug", valueLabel: slugLabel),
            makeSection(title: "URL", valueLabel: urlLabel, isLink: true)
        ])
        
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        favStackView.axis = .horizontal
        favStackView.spacing = 8
        favStackView.alignment = .center
        favStackView.distribution = .fill
        

        NSLayoutConstraint.activate([
            favouriteButton.widthAnchor.constraint(equalToConstant: 45)
        ])
        favouriteButton.addTarget(self, action: #selector(handleFavoriteTap), for: .touchUpInside)
        updateFavoriteButton(isFavorite: viewModel.isFavorite)
        favStackView.addArrangedSubview(titleLabel)
        favStackView.addArrangedSubview(favouriteButton)

        contentStack.addArrangedSubview(favStackView)
        contentStack.addArrangedSubview(detailsCard)
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        favouriteButton.setImage(isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
    }
    
    func makeCardView(with sections: [UIView]) -> UIView {
        let card = UIStackView(arrangedSubviews: sections)
        card.axis = .vertical
        card.spacing = 12
        card.alignment = .fill
        card.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        card.isLayoutMarginsRelativeArrangement = true
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.1
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 6
        return card
    }
    
    func makeSection(title: String, valueLabel: UILabel, isLink: Bool = false) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.numberOfLines = 0
        
        if isLink {
            valueLabel.textColor = .link
            valueLabel.isUserInteractionEnabled = true
            valueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openURL)))
        }
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
    
    @objc func openURL() {
        guard let url = URL(string: viewModel.url) else { return }
        UIApplication.shared.open(url)
    }
    @objc func handleFavoriteTap() {
        viewModel.handleFavoriteTap()
    }
}
