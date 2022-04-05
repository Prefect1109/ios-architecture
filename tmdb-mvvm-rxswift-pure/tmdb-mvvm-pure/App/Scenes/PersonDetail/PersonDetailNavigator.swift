//
//  PersonDetailNavigator.swift
//  tmdb-mvvm-pure
//
//  Created by Prefect on 05.04.2022.
//  Copyright © 2022 tailec. All rights reserved.
//

import UIKit

protocol PersonDetailNavigatable {
    func goBack()
}

final class PersonDetailNavigator: PersonDetailNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
