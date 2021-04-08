//
//  MainModel.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 18.03.2021.
//

import Foundation
protocol MainModel: class {
    var symbolsForLoad: Set<String> {get set}
    var maxNumberSymbols: Int {get set}
    var loadSymbols: Array<String> {get set}
    var presenter: MainPresenter? {get}
    var favorites: Array<String> {get set}
}

class MainModelImplementation: MainModel{
    var maxNumberSymbols: Int = 0
    var symbolsForLoad: Set<String> = []
    var loadSymbols: Array<String> = []
    var favorites: Array<String> = []
    weak var presenter: MainPresenter?
}
