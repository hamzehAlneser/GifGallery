//
//  SearchViewController.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

import UIKit

final class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel
    // MARK: - UI Properties
    private let tableView = UITableView()
    private let tableFooterLoader = UIActivityIndicatorView(style: .medium)
    private let searchController = UISearchController()
    private var searchTimer: Timer?
    //MARK: - Life Cycle
    init(viewModel: SearchViewModel) {
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
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search fruits"
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkFavorites()
    }
    
}

//MARK: - Binding & Logic
extension SearchViewController {
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
                hideLoader()
                tableView.tableFooterView?.isHidden = true
            }
        }
        
        viewModel.searchDataError = { [weak self] errorText in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                hideLoader()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
            guard let self else { return }
            viewModel.loadMoreData(searchText: searchController.searchBar.text)
        }
    }
}

//MARK: - Search Delegates
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { [weak self] _ in
            guard let self else { return }
            showLoader()
            viewModel.fetchData(searchText: searchController.searchBar.text)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showLoader()
        viewModel.fetchData(searchText: searchBar.text)
    }
}
//MARK: - Tableview Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.searchCellViewModels.count - 1 && viewModel.hasMoreData {
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToDetails(cellVM: viewModel.searchCellViewModels[indexPath.row])
    }
}

//MARK: - Tableview Datasource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableviewCell.reuseIdentifier, for: indexPath) as? ItemTableviewCell else { return UITableViewCell()}
        let cellViewModel = viewModel.searchCellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell

    }
}

//MARK: - UI
extension SearchViewController {
    private func setupUI() {
        title = "Search"
        setupHierarchy()
        setupTableviewUI()
        setupTableFooterLoader()
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
}

//MARK: - Layout
extension SearchViewController {
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

