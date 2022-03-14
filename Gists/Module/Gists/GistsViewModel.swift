//
//  GistsViewModel.swift
//  Gists
//
//  Created by Mohammad Assad on 11/03/2022.
//

import Foundation
import RxSwift
import RxCocoa


class GistsViewModel {
    
    
    private var gistsRepo: GistsRepoProtocol
    
    // dispose bag to get rid of the subscribers when the class is destroyed to prevent memory leak
    private let disposeBag = DisposeBag()
    
    
    // relays that publish values and you subscribe to it at viewController
    var gistsRelay = BehaviorRelay<GistsModel>(value: [])
    var errorRelay = BehaviorRelay<String>(value: "")
    var loadingRelay = BehaviorRelay<Bool>(value: false)
    
    
    // initializers
    init(gistsRepo: GistsRepoProtocol = GistsRepo()) {
        self.gistsRepo = gistsRepo
    }
    
    
    
    func getGistsList() {
        
        loadingRelay.accept(true)
        
        gistsRepo.getGists().subscribe { [weak self] gistsList in
            self?.loadingRelay.accept(false)
            self?.gistsRelay.accept(gistsList)
        } onError: { [weak self] error in
            self?.loadingRelay.accept(false)
            guard let error = error as? NetworkError else { return }
            self?.errorRelay.accept(error.errorDescription)
        }.disposed(by: disposeBag)

    }
    
}
