//
//  PersonDetailViewModel.swift
//  tmdb-mvvm-pure
//
//  Created by Prefect on 05.04.2022.
//  Copyright © 2022 tailec. All rights reserved.
//

import RxCocoa
import RxSwift

class PersonDetailViewModel: ViewModelType {
    struct Input {
        let ready: Driver<Void>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<PersonalDetailData?>
        let back: Driver<Void>
    }
    
    struct Dependencies {
        let id: Int
        let api: TMDBApiProvider
        let navigator: PersonDetailNavigator
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let data = input.ready
            .asObservable()
            .flatMap {_ in
                self.dependencies.api.fetchPersonDetails(forPersonId: self.dependencies.id)
            }
            .map { personDetail -> PersonalDetailData? in
                guard let personDetail = personDetail else { return nil }
                return PersonalDetailData(personDetail: personDetail)
            }
            .asDriver(onErrorJustReturn: nil)
        
        let back = input.backTrigger
            .do(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.dependencies.navigator.goBack()
                
            })
                
        return .init(data: data, back: back)
    }
}

struct PersonalDetailData {
    let name: String
    let personImage: String?
}

extension PersonalDetailData {
    init(personDetail: PersonDetail) {
        self.name = personDetail.name
        self.personImage = personDetail.profileUrl.flatMap { "http://image.tmdb.org/t/p/w185/" + $0 }
    }
}
