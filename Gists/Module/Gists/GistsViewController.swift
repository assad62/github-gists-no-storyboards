//
//  GistsViewController.swift
//  Gists
//
//  Created by Mohammad Assad on 11/03/2022.
//

import UIKit
import RxSwift

class GistsViewController: UIViewController {
    
    
    private let viewModel = GistsViewModel()
    
    
    // dispose bag to get rid of the subscribers when the class is destroyed to prevent memory leak
    private let bag = DisposeBag()
    
    
    // User interface variables
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(GistCell.self, forCellReuseIdentifier: "GistCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loadingView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let ai = UIActivityIndicatorView()
        ai.style = .whiteLarge
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ai)
        NSLayoutConstraint.activate([
            ai.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ai.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }
    
    
    /// here we subscribing to the relayes in the view model
    /// when a single relay publish any value, it executes the code in the closure
    /// make sure to subscribe before you call the api
    private func bindViewModel() {
        
        viewModel.gistsRelay.subscribe(onNext: { [weak self] gistsList in
            self?.tableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.errorRelay.subscribe(onNext: { [weak self] error in
            guard !error.isEmpty else { return }
            self?.showAlert(error)
        }).disposed(by: bag)
        
        viewModel.loadingRelay.subscribe(onNext: { [weak self] isLoading in
            self?.loadingView.alpha = isLoading ? 1 : 0
        }).disposed(by: bag)
        
        
        viewModel.getGistsList()
    }
    
    /// add all subviews to the view
    /// add constraints to the subviews
    private func setupUI() {
        title = "Gists"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.heightAnchor.constraint(equalTo: view.heightAnchor),
            loadingView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
    }

}

extension GistsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gistsRelay.value.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GistCell", for: indexPath) as! GistCell
        cell.configure(gistModel: viewModel.gistsRelay.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = viewModel.gistsRelay.value[indexPath.row]
        navigationController?.pushViewController(GistDetailsViewController.instance(gistsModelElement: element), animated: true)
    }
    
    
    /// adjust dynamic height depending on labels height in cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellContent = viewModel.gistsRelay.value[indexPath.row]
        let fontUsed = UIFont.systemFont(ofSize: 16, weight: .medium)
        let width = UIScreen.main.bounds.width - 110
        let height1 = "ID : \(cellContent.owner.id)".height(withConstrainedWidth: width, font: fontUsed)
        let height2 = ("URL : "  + cellContent.owner.htmlURL).height(withConstrainedWidth: width, font: fontUsed)
        let height3 = ("File : " + (cellContent.files.keys.first ?? "")).height(withConstrainedWidth: width, font: fontUsed) + 60
        return height1 + height2 + height3
    }

    
    
}
