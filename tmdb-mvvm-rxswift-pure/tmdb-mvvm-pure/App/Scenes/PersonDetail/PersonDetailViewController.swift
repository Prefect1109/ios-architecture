//
//  PersonDetailViewController.swift
//  tmdb-mvvm-pure
//
//  Created by Prefect on 05.04.2022.
//  Copyright © 2022 tailec. All rights reserved.
//

import RxSwift
import Nuke

class PersonDetailViewController: UIViewController {
    var viewModel: PersonDetailViewModel!
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func bindViewModel() {
        let input = PersonDetailViewModel.Input(ready: rx.viewWillAppear.asDriver(),
                                                backTrigger: backButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.data
            .drive(onNext: { [weak self] data in
                guard let data = data,
                    let strongSelf = self else { return }
                strongSelf.personNameLabel.text = data.name
                if let url = data.personImage {
                    Nuke.loadImage(with: URL(string: url)!, into: strongSelf.personImageView)
                }
            })
            .disposed(by: disposeBag)
        
        output.back
            .drive()
            .disposed(by: disposeBag)
    }
}

