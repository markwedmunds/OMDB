//
//  ListViewController.swift
//  OMDB
//
//  Created by Mark Edmunds on 21/11/2020.
//  Copyright © 2020 Mark Edmunds. All rights reserved.
//

import UIKit
import AlamofireImage

class ListViewController: UIViewController {
  // MARK: Properties
  weak var coordinator: MainCoordinator?
  var viewModel: ListViewControllerViewModel?
  
  var items: [Displayable] = []
  
  let cellReuseIdendifier = "cell"
  
  let imageCache = AutoPurgingImageCache()
  
  // MARK: - View Properties
  
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.searchBarStyle = .prominent
    searchBar.placeholder = "Search OMDb for movies..."
    searchBar.isTranslucent = false
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    return searchBar
  }()
  
  private let tableViewController: UITableViewController = {
    let tableViewController = UITableViewController()
    tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableViewController
  }()
  
  // MARK: - Lifecycle
  
  override func loadView() {
    super.loadView()
    
    self.view.backgroundColor = .white
    
    searchBar.delegate = self
    
    tableViewController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdendifier)
    tableViewController.tableView.dataSource = self
    tableViewController.tableView.delegate = self
    
    self.view.addSubview(searchBar)
    self.view.addSubview(tableViewController.tableView)
    
    self.layoutElements()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let omdbService = OMDBServiceImpl()

    viewModel = ListViewControllerViewModelImpl(omdbService: omdbService)
    viewModel?.delegate = self
  }

  // MARK: - Layout
  
  private func layoutElements() {
    NSLayoutConstraint.activate([
      self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      self.searchBar.heightAnchor.constraint(equalToConstant: 60.0),
      self.searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
      self.tableViewController.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
      self.tableViewController.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      self.tableViewController.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
    ])
  }
}

// MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    viewModel?.search(text: text)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.resignFirstResponder()
    items = []
    tableViewController.tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.titleLabelText
    cell.detailTextLabel?.text = item.subtitleLabelText
    
    if let imageUrl = URL(string: item.imageUrl) {
      cell.imageView?.af.setImage(
        withURL: imageUrl,
        placeholderImage: nil,
        filter: AspectScaledToFillSizeWithRoundedCornersFilter(
          size: CGSize(width: 100, height: 100),
          radius: 20.0
        ),
        imageTransition: .crossDissolve(0.2)
      )
    }
    
    return cell
  }
}

// MARK: - ListViewControllerViewModelDelegate

extension ListViewController: ListViewControllerViewModelDelegate {
  func refreshTableView() {
    if let items = viewModel?.items {
      self.items = items
    }
    
    tableViewController.tableView.reloadData()
  }
  
  func moveToDetailScreen() {
    coordinator?.splash()
  }

  func displayError(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)

    present(alertController, animated: true, completion: nil)
  }
}
