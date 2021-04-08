//
//  SharesTableViewCell.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 15.03.2021.
//

import UIKit

class SharesTableViewCell: UITableViewCell {
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 18)
        return label
    }()
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 18)
        return label
    }()
    
    let changesForDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.textColor = UIColor(red: 36/256, green: 178/256, blue: 93/256, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.cornerRadius = 16
        //contentView
        contentView.addSubview(companyImageView)
        contentView.addSubview(tickerLabel)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(favouriteButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changesForDayLabel)
        
        companyImageView.translatesAutoresizingMaskIntoConstraints = false
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        changesForDayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        companyImageView.widthAnchor.constraint(equalToConstant: 52),
                                        companyImageView.heightAnchor.constraint(equalToConstant: 52),
                                        companyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                                        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
                                        companyImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)])
        
        NSLayoutConstraint.activate([tickerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
                                     tickerLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 12)])
        
        NSLayoutConstraint.activate([companyNameLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 12),
                                     companyNameLabel.rightAnchor.constraint(equalTo: changesForDayLabel.leftAnchor, constant: -12),
                                     companyNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
                                     companyNameLabel.topAnchor.constraint(equalTo: tickerLabel.bottomAnchor, constant: 5)])
        
        NSLayoutConstraint.activate([favouriteButton.centerYAnchor.constraint(equalTo: tickerLabel.centerYAnchor),
                                     favouriteButton.leftAnchor.constraint(equalTo: tickerLabel.rightAnchor, constant: 6),
                                     favouriteButton.heightAnchor.constraint(equalToConstant: 16),
                                     favouriteButton.widthAnchor.constraint(equalToConstant: 16)])
        
        NSLayoutConstraint.activate([priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                                     priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -18)])
        
        NSLayoutConstraint.activate([changesForDayLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 6),
                                     changesForDayLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -18),
                                     changesForDayLabel.widthAnchor.constraint(equalToConstant: 35)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
