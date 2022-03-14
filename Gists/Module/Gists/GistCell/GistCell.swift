//
//  GistCell.swift
//  Gists
//
//  Created by Mohammad Assad on 12/03/2022.
//

import UIKit

class GistCell: UITableViewCell {
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.cornerRadius = 30
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
    
    private lazy var fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        contentView.addSubview(bgView)
        bgView.addSubview(userImageView)
        bgView.addSubview(idLabel)
        bgView.addSubview(urlLabel)
        bgView.addSubview(fileNameLabel)
        
        NSLayoutConstraint.activate([
            
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            userImageView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10),
            userImageView.heightAnchor.constraint(equalToConstant: 60),
            userImageView.widthAnchor.constraint(equalToConstant: 60),

            urlLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            urlLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            urlLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10),
            
            idLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            idLabel.bottomAnchor.constraint(equalTo: urlLabel.topAnchor, constant: -5),
            
            fileNameLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 5),
            fileNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            fileNameLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10)
            
        ])
    }
    
    func configure(gistModel: GistsModelElement) {
        userImageView.downloadFromURL(gistModel.owner.avatarURL)
        idLabel.text = "ID : \(gistModel.owner.id)"
        urlLabel.text = "URL : " + gistModel.owner.htmlURL
        fileNameLabel.text = "File : " + (gistModel.files.keys.first ?? "")
        
        
        
    }

}
