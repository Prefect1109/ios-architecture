//
//  ShowDetailNavigator.swift
//  tmdb-mvvm-pure
//
//  Created by Prefect on 05.04.2022.
//  Copyright © 2022 tailec. All rights reserved.
//

import UIKit

protocol ShowDetailNavigatable {
    func goBack()
}

final class ShowDetailNavigator: ShowDetailNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
