//
//  ListViewControllerViewModel.swift
//  OMDB
//
//  Created by Mark Edmunds on 21/11/2020.
//  Copyright © 2020 Mark Edmunds. All rights reserved.
//

import Foundation

protocol ListViewControllerViewModel {
  var delegate: ListViewControllerViewModelDelegate? { get set }

  init(omdbService: OMDBService)
  
  var items: [Displayable] { get }

  func search(text: String)
}

protocol ListViewControllerViewModelDelegate: class {
  func refreshTableView()
  func moveToDetailScreen()
  func displayError(title: String, message: String)
}

class ListViewControllerViewModelImpl: ListViewControllerViewModel {
  weak var delegate: ListViewControllerViewModelDelegate?

  var omdbService: OMDBService
  
  var items: [Displayable] = []

  required init(omdbService: OMDBService) {
    self.omdbService = omdbService
  }

  // MARK - Actions

  func search(text: String) {
    do {
      try self.omdbService.searchMovieByTitle(title: text) { movies in
        guard let movies = movies else {
          self.delegate?.displayError(title: "No Results", message: "There were no results")
          return
        }
        self.items = movies.all
        self.tellDelegateToRefreshTableView()
      }
    } catch OMDBServiceError.invalidURL {
      delegate?.displayError(title: "Error", message: "There was a problem encoding the URL")
    } catch {
      delegate?.displayError(title: "Error", message: "There was a problem while fetching results")
    }
  }

  // MARK: - Delegate Response

  private func tellDelegateToRefreshTableView() {
    delegate?.refreshTableView()
  }
  
  private func tellDelegateToMoveToDetailScreen() {
    delegate?.moveToDetailScreen()
  }

  private func tellDelegateToDisplayError(message: String) {
    delegate?.displayError(title: "Error", message: message)
  }
}
