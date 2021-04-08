//
//  ViewController.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 14.03.2021.
//

import UIKit


protocol MainViewController: class {
    
    var maxNumberOfRow: Int {get set}
    var presenter: MainPresenter! {get}
    func updateTableview()
    func loadData(isActiv: Bool)
}

class ViewController: UIViewController, MainViewController  {
    var maxNumberOfRow: Int = 0
    var presenter: MainPresenter!
    private var mainView = MainView()
    private var isLoadData = false
    private var numberOfDisplayedCell = 0
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.sharesTableView.dataSource = self
    }
    
    func updateTableview() {
        mainView.sharesTableView.reloadData()
    }
    
    
    func loadData(isActiv: Bool) {
        isLoadData = isActiv
    }
    
    @objc
    func actionFavoriteButton(sender: UIButton){
        presenter.changeShareFavoriteStatus(index: sender.tag)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard presenter != nil else {
            return 0
        }
        if isLoadData {
            numberOfDisplayedCell = presenter.numberOfDisplayedCell()
            return numberOfDisplayedCell + 1
        }
        numberOfDisplayedCell = presenter.numberOfDisplayedCell()
        return presenter.numberOfDisplayedCell()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let background = indexPath.row % 2 == 0 ? UIColor(red: 240/256, green: 244/256, blue: 247/256, alpha: 1) : .white
        
        if (numberOfDisplayedCell <= indexPath.row + 2500) && (!isLoadData) && (numberOfDisplayedCell != maxNumberOfRow){
            presenter.loadPagingData()
        }
        
        if (numberOfDisplayedCell  == indexPath.row ) && (isLoadData) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "load") as! LoadDataTableViewCell
            cell.loadActivityIndicatorView.startAnimating()
            cell.backgroundColor = background
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aaa") as! SharesTableViewCell
            let profilCompany = presenter.obtainShareNameCompanyFor(indexPath: indexPath)
            
            cell.tickerLabel.text = profilCompany.tiker
            cell.companyNameLabel.text = profilCompany.nameConpany
            let imageCell = UIImage(data: profilCompany.logoData ?? Data())
            cell.companyImageView.image = imageCell ?? UIImage(named: "placeholderUSDollar")
            var priceString = String(profilCompany.price ?? 0)
            if profilCompany.currency == "USD"{
                priceString = "$ \(priceString)"
            }
            cell.priceLabel.text = priceString
            if  (profilCompany.changesForDay ?? 0) < 0 {
                cell.changesForDayLabel.textColor = .red
            }
            else{cell.changesForDayLabel.textColor = UIColor(red: 36/256, green: 178/256, blue: 93/256, alpha: 1)}
            cell.changesForDayLabel.text = String(format: "%.2f", profilCompany.changesForDay ?? 0)
            cell.backgroundColor = background
            if presenter.obtainShareFavoriteStatus(index: indexPath.row) {
                cell.favouriteButton.setImage(UIImage(named: "StarFavourite"), for: .normal)
            } else {
                cell.favouriteButton.setImage(UIImage(named: "StarNotFavourite"), for: .normal)
            }
            cell.favouriteButton.tag = indexPath.row
            cell.favouriteButton.addTarget(self, action: #selector(actionFavoriteButton(sender:)) , for: .touchUpInside)
            
            return cell
        }
    }
}

