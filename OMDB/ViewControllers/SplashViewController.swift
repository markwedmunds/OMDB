//
//  SplashViewController.swift
//  OMDB
//
//  Created by Mark Edmunds on 21/11/2020.
//  Copyright © 2020 Mark Edmunds. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
  weak var coordinator: MainCoordinator?
  
  // MARK: - View Properties
  
  private let loadingLabel: UILabel = {
    let label = UILabel()
    label.text = "Loading"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let activityIndicator: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.style = UIActivityIndicatorView.Style.gray
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    return activityIndicatorView
  }()
  
  // MARK: - Lifecycle
  
  override func loadView() {
    super.loadView()
    
    self.view.backgroundColor = .white
    
    self.view.addSubview(loadingLabel)
    self.view.addSubview(activityIndicator)
    
    self.layoutElements()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.activityIndicator.startAnimating()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.coordinator?.list()
    }
  }
  
  // MARK: - Layout
  
  private func layoutElements() {
    NSLayoutConstraint.activate([
      self.loadingLabel.centerXAnchor.constraint(equalTo: self.activityIndicator.centerXAnchor),
      self.loadingLabel.bottomAnchor.constraint(equalTo: self.activityIndicator.topAnchor, constant: -10),
      self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    ])
  }
}
