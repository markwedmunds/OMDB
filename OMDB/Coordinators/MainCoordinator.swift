//
//  MainCoordinator.swift
//  OMDB
//
//  Created by Mark Edmunds on 21/11/2020.
//  Copyright © 2020 Mark Edmunds. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = [Coordinator]()
  var navigationController: UINavigationController = UINavigationController()
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func splash() {
    let vc = SplashViewController()
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: false)
  }
  
  func list() {
    let vc = ListViewController()
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: false)
  }
}
