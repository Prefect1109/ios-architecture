//
//  DiscoverNavigator.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 27/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

protocol DiscoverNavigatable {
    func navigateToMovieDetailScreen(withMovieId id: Int, api: TMDBApiProvider)
    func navigateToPersonDetailScreen(withPersonId id: Int, api: TMDBApiProvider)
    func navigateToShowDetailScreen(withShowId id: Int, api: TMDBApiProvider)
}

final class DiscoverNavigator: DiscoverNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToMovieDetailScreen(withMovieId id: Int, api: TMDBApiProvider) {
        let movieDetailNavigator = MovieDetailNavigator(navigationController: navigationController)
        let movieDetailViewModel = MovieDetailViewModel(dependencies: MovieDetailViewModel.Dependencies(id: id,
                                                                                                        api: api,
                                                                                                        navigator: movieDetailNavigator))
        let movieDetailViewController = UIStoryboard.main.movieDetailViewController
        movieDetailViewController.viewModel = movieDetailViewModel
        
        navigationController.show(movieDetailViewController, sender: nil)
    }
    
    func navigateToPersonDetailScreen(withPersonId id: Int, api: TMDBApiProvider) {
        let personDetailNavigator = PersonDetailNavigator(navigationController: navigationController)
        let personDetailViewModel = PersonDetailViewModel(dependencies: PersonDetailViewModel.Dependencies(id: id,
                                                                                                          api: api,
                                                                                                          navigator: personDetailNavigator))
        let personDetailViewController = UIStoryboard.main.personDetailViewController
        personDetailViewController.viewModel = personDetailViewModel
        
        navigationController.show(personDetailViewController, sender: nil)
    }
    
    func navigateToShowDetailScreen(withShowId id: Int, api: TMDBApiProvider) {
        let showDetailNavigator = ShowDetailNavigator(navigationController: navigationController)
        let showDetailViewModel = ShowDetailViewModel(dependencies: ShowDetailViewModel.Dependencies(id: id,
                                                                                                  api: api,
                                                                                                  navigator: showDetailNavigator))
        let showDetailViewController = UIStoryboard.main.showDetailViewController
        showDetailViewController.viewModel = showDetailViewModel
        
        navigationController.show(showDetailViewController, sender: nil)
    }
}
