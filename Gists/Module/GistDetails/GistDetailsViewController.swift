//
//  GistDetailsViewController.swift
//  Gists
//
//  Created by Mohammad Assad on 12/03/2022.
//

import UIKit
import RxSwift

class GistDetailsViewController: UIViewController {

    private var viewModel: GistDetailsViewModel!
    
    // dispose bag to get rid of the subscribers when the class is destroyed to prevent memory leak
    private let bag = DisposeBag()
    
    
    private var gistModelElement: GistsModelElement!
    
    
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
    
    private lazy var userImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 40
        iv.image = UIImage(named: "user")
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var staticUserGistsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "User Gists"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    /// to intiate the view controller with gist model element value
    static func instance(gistsModelElement: GistsModelElement) -> GistDetailsViewController {
        let vc = GistDetailsViewController()
        vc.gistModelElement = gistsModelElement
        vc.viewModel = GistDetailsViewModel(gistDetailsRepo: GistDetailsRepo(userName: gistsModelElement.owner.login))
        return vc
    }
    
    /// here we subscribing to the relayes in the view model
    /// when a single relay publish any value, it executes the code in the closure
    /// make sure to subscribe before you call the api
    private func bindViewModel() {
        
        viewModel.userGistsRelay.subscribe(onNext: { [weak self] gistsList in
            guard let self = self, !gistsList.isEmpty else { return }
            self.tableView.reloadData()
            self.userImageView.downloadFromURL(self.gistModelElement.owner.avatarURL)
            self.idLabel.text = "ID : \(self.gistModelElement.owner.id)"
            self.urlLabel.text = "URL : " + self.gistModelElement.owner.htmlURL
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
        title = "Gist Details"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = .white
        
        view.addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userImageView.heightAnchor.constraint(equalToConstant: 80),
            userImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        
        view.addSubview(idLabel)
        NSLayoutConstraint.activate([
            idLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            idLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: -10),
            idLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ])
        
        
        view.addSubview(urlLabel)
        NSLayoutConstraint.activate([
            
            
            urlLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: 10),
            urlLabel.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor),
            urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ])
        
        view.addSubview(staticUserGistsLabel)
        NSLayoutConstraint.activate([
            
            staticUserGistsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            staticUserGistsLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20)
        ])

        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: staticUserGistsLabel.bottomAnchor, constant: 10),
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

extension GistDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userGistsRelay.value.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GistCell", for: indexPath) as! GistCell
        cell.configure(gistModel: viewModel.userGistsRelay.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    /// adjust dynamic height depending on labels height in cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellContent = viewModel.userGistsRelay.value[indexPath.row]
        let fontUsed = UIFont.systemFont(ofSize: 16, weight: .medium)
        let width = UIScreen.main.bounds.width - 110
        let height1 = "ID : \(cellContent.owner.id)".height(withConstrainedWidth: width, font: fontUsed)
        let height2 = ("URL : "  + cellContent.owner.htmlURL).height(withConstrainedWidth: width, font: fontUsed)
        let height3 = ("File : " + (cellContent.files.keys.first ?? "")).height(withConstrainedWidth: width, font: fontUsed) + 60
        return height1 + height2 + height3
    }

    
    
}
