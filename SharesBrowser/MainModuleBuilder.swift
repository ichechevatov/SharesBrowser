//
//  MainModuleBuilder.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 18.03.2021.
//

import UIKit


class MainModuleBuilder {
    class func create() -> UIViewController {
        let vc = ViewController()
        let model = MainModelImplementation()
        let ns = NetworkServiceImplimentation()
        let presenter = MainPresenterImplementation(viewController: vc , model: model, networkService: ns)
        model.presenter = presenter
        vc.presenter = presenter
        return vc
    }
    deinit {
        print("DEINIT")
    }
}
