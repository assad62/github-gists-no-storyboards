//
//  GistDetailsViewModel.swift
//  Gists
//
//  Created by Mohammad Assad on 12/03/2022.
//

import Foundation
import RxSwift
import RxCocoa


class GistDetailsViewModel {
    
    
    private var gistDetailsRepo: GistDetailsRepoProtocol
    
    // dispose bag to get rid of the subscribers when the class is destroyed to prevent memory leak
    private let disposeBag = DisposeBag()
    
    
    // relays that publish values and you subscribe to it at viewController
    var userGistsRelay = BehaviorRelay<GistsModel>(value: [])
    var errorRelay = BehaviorRelay<String>(value: "")
    var loadingRelay = BehaviorRelay<Bool>(value: false)
    
    
    // initializers
    init(gistDetailsRepo: GistDetailsRepoProtocol) {
        self.gistDetailsRepo = gistDetailsRepo
    }
    
    
    
    func getGistsList() {
        loadingRelay.accept(true)
        gistDetailsRepo.getUserGists().subscribe { [weak self] gistsList in
            self?.loadingRelay.accept(false)
            self?.userGistsRelay.accept(gistsList)
        } onError: { [weak self] error in
            self?.loadingRelay.accept(false)
            guard let error = error as? NetworkError else { return }
            self?.errorRelay.accept(error.errorDescription)
        }.disposed(by: disposeBag)

    }
    
    
}
