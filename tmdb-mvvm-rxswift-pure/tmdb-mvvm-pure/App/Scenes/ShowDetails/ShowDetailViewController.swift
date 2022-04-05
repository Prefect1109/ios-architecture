//
//  ShowDetailViewController.swift
//  tmdb-mvvm-pure
//
//  Created by Prefect on 05.04.2022.
//  Copyright © 2022 tailec. All rights reserved.
//

import RxSwift
import RxCocoa
import Nuke

final class ShowDetailViewController: UIViewController {
    var viewModel: ShowDetailViewModel!
    
    @IBOutlet weak var headerView: MovieDetailHeaderView!
    @IBOutlet weak var tipsView: MovieDetailTipsView!
    @IBOutlet weak var posterImageView: GradientImageView!
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
    
    private func bindViewModel() {
        let input = ShowDetailViewModel.Input(ready: rx.viewWillAppear.asDriver(),
                                               backTrigger: backButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.data
            .drive(onNext: { [weak self] data in
                guard let data = data,
                    let strongSelf = self else { return }
                strongSelf.headerView.configure(with: data)
                strongSelf.tipsView.configure(with: data)
                if let url = data.posterUrl {
                    Nuke.loadImage(with: URL(string: url)!, into: strongSelf.posterImageView)
                }
            })
            .disposed(by: disposeBag)
        
        output.back
            .drive()
            .disposed(by: disposeBag)
    }
}

