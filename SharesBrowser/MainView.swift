//
//  MainView.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 14.03.2021.
//

import UIKit
import Alamofire

class MainView: UIView {
    
    lazy var search: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barStyle = .default
        searchBar.placeholder = "Find company or ticker"
        searchBar.showsSearchResultsButton = true
        
        return searchBar
    }()
    
    lazy var sharesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SharesTableViewCell.self, forCellReuseIdentifier: "aaa")
        tableView.register(LoadDataTableViewCell.self, forCellReuseIdentifier: "load")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 68
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        addSubview(search)
        NSLayoutConstraint.activate([
                                        search.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                                        search.leftAnchor.constraint(equalTo: leftAnchor),
                                        search.widthAnchor.constraint(equalTo: widthAnchor)])
        
        addSubview(sharesTableView)
        NSLayoutConstraint.activate([sharesTableView.topAnchor.constraint(equalTo: search.bottomAnchor),
                                     sharesTableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                     sharesTableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
                                     sharesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView: UISearchBarDelegate {
    
}


