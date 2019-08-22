//
//  GistTableViewCell.swift
//  GistApp
//
//  Created by User on 09/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
// A class for custom Gist tableView cell
class GistTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
   
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gist name:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
        
    }()
    
    private let urlTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "URL:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
        
    }()

    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
    }
    // MARK: - Private functions
    
    private func setupUI(){
        addSubview(nameTitleLabel)
        addSubview(urlTitleLabel)
       
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        urlTitleLabel.translatesAutoresizingMaskIntoConstraints = false
      
        
        addSubview(urlLabel)
        addSubview(nameLabel)
        addSubview(dateLabel)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            nameTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            nameTitleLabel.widthAnchor.constraint(equalToConstant: 90),
            
            urlTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            urlTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 10),
            urlTitleLabel.widthAnchor.constraint(equalToConstant: 90),
            
          
            
            nameLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: nameTitleLabel.topAnchor),
            
            urlLabel.leadingAnchor.constraint(equalTo: urlTitleLabel.trailingAnchor, constant: 10),
            urlLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            urlLabel.topAnchor.constraint(equalTo: urlTitleLabel.topAnchor),
            
            
            
            dateLabel.leadingAnchor.constraint(equalTo: urlLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: urlLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
            ])
       
        
    }
    
    // MARK: - Public functions
    
    func setDataToCell(model: Gist){
        urlLabel.text = model.url
        dateLabel.text = model.created_at.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")
        nameLabel.text = model.files.map({$0.value.filename})[0]
    }

    

}
