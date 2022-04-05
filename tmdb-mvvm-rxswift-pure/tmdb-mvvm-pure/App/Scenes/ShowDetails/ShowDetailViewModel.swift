//
//  ShowDetailViewModel.swift
//  tmdb-mvvm-pure
//
//  Created by Prefect on 05.04.2022.
//  Copyright © 2022 tailec. All rights reserved.
//

import RxSwift
import RxCocoa

class ShowDetailViewModel {
    struct Input {
        let ready: Driver<Void>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<ShowDetailData?> // nil means TMDB API errored out
        let back: Driver<Void>
    }
    
    struct Dependencies {
        let id: Int
        let api: TMDBApiProvider
        let navigator: ShowDetailNavigator
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: ShowDetailViewModel.Input) -> ShowDetailViewModel.Output {
        let data = input.ready
            .asObservable()
            .flatMap {_ in
                self.dependencies.api.fetchShowDetails(forShowId: self.dependencies.id)
            }
            .map { showDetail -> ShowDetailData? in
                guard let showDetail = showDetail else { return nil }
                return ShowDetailData(showDetail: showDetail)
            }
            .asDriver(onErrorJustReturn: nil)
        
        let back = input.backTrigger
            .do(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.dependencies.navigator.goBack()
                
            })
        
        return Output(data: data, back: back)
    }
}

struct ShowDetailData {
    let title: String
    let releaseDate: String
    let overview: String
    let genres: String
    let runtime: String
    let voteAverage: String
    let posterUrl: String?
    let voteCount: String
    let status: String
}

extension ShowDetailData {
    init(showDetail: ShowDetail) {
        self.title = showDetail.name
        self.releaseDate = showDetail.releaseDate
        self.overview = showDetail.overview
        self.genres = showDetail.genres
            .flatMap {
                $0.map { $0.name }
                    .prefix(2)
                    .joined(separator: ", ")
            } ?? ""
        let episodeRunTimeInt = showDetail.episodeRunTime.reduce(0, +)
        print(episodeRunTimeInt)
        self.runtime = "\(episodeRunTimeInt / 60)hr \(episodeRunTimeInt % 60)min"
        self.voteAverage = showDetail.voteAverage
            .flatMap { String($0) } ?? ""
        self.posterUrl = showDetail.posterUrl.flatMap { "http://image.tmdb.org/t/p/w780/" + $0 }
        self.voteCount = showDetail.voteCount
            .flatMap { String($0) } ?? ""
        self.status = showDetail.status ?? ""
    }
}
