//
//  LoadDataTableViewCell.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 19.03.2021.
//

import UIKit

class LoadDataTableViewCell: UITableViewCell {
    lazy var loadActivityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.isHidden = false
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    var lab: UILabel = {
        let lab = UILabel()
        lab.text = "text"
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.cornerRadius = 16
        addSubview(loadActivityIndicatorView)
        addSubview(lab)
        loadActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        lab.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([loadActivityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     loadActivityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)])
        
        NSLayoutConstraint.activate([lab.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     lab.centerYAnchor.constraint(equalTo: centerYAnchor)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
