//
//  HomeViewController.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//
import UIKit

final class HomeViewController: BaseViewController {
    private let viewModel: HomeViewModel
    // MARK: - UI Properties
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let tableFooterLoader = UIActivityIndicatorView(style: .medium)
    //MARK: - Life Cycle
    init(viewModel: HomeViewModel) {
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
        bindViewModel()
        
        showLoader()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkFavorites()
    }
    
}

//MARK: - Binding & Logic
extension HomeViewController {
    private func bindViewModel() {
        viewModel.onLoadData = { [weak self] items, indexPaths in
            guard let self else { return }
            bindCellViewModel(cellViewModels: items, indexPaths: indexPaths)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if(viewModel.isFirstPage) {
                    tableView.reloadData()
                } else {
                    self.tableView.insertRows(at: indexPaths, with: .none)
                }
                refreshControl.endRefreshing()
                hideLoader()
                tableView.tableFooterView?.isHidden = true
            }
        }
        
        viewModel.homeDataError = { [weak self] errorText in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                hideLoader()
                refreshControl.endRefreshing()
                tableView.tableFooterView?.isHidden = true
                showAlert(title: "Error", text: errorText)
            }
        }
    }
    
    private func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.fetchInitialData()
        }
    }
    
    private func bindCellViewModel(cellViewModels: [ItemTableviewCellVM], indexPaths: [IndexPath]) {
        for (viewModel, indexPath) in zip(cellViewModels, indexPaths) {
            viewModel.onGifLoaded = { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let cell = self.tableView.cellForRow(at: indexPath) as? ItemTableviewCell {
                        cell.updateImage(using: viewModel.image)
                    }
                }
            }
            viewModel.loadImage()
        }
    }
    
    private func loadMoreData() {
        tableFooterLoader.startAnimating()
        tableView.tableFooterView?.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.loadMoreData()
        }
    }
}

//MARK: - Tableview Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.homeCellViewModels.count - 1 && viewModel.hasMoreData {
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToDetails(cellVM: viewModel.homeCellViewModels[indexPath.row])
    }
}

//MARK: - Tableview Datasource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.homeCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableviewCell.reuseIdentifier, for: indexPath) as? ItemTableviewCell else { return UITableViewCell()}
        let cellViewModel = viewModel.homeCellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell

    }
}

//MARK: - UI
extension HomeViewController {
    private func setupUI() {
        title = "Explore"
        setupHierarchy()
        setupTableviewUI()
        setupTableFooterLoader()
        setupRefreshControl()
    }
    
    private func setupHierarchy() {
        view.addSubviews(tableView.useCodeLayout())
    }
    
    private func setupTableviewUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemTableviewCell.self, forCellReuseIdentifier: ItemTableviewCell.reuseIdentifier)
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupTableFooterLoader() {
        tableFooterLoader.color = .accent
        tableView.tableFooterView = tableFooterLoader
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .accent
    }
    @objc private func didPullToRefresh() {
        fetchData()
    }
}

//MARK: - Layout
extension HomeViewController {
    private func setupLayout() {
        setupTableviewLayout()
    }
    
    private func setupTableviewLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
