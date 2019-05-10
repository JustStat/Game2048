//
//  ViewController.swift
//  Game2048
//
//  Created by Kirill Varlamov on 09/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .background
        let gameFieldConfig = GameFieldConfiguration(backgroundColor: .background, cellColor: .cellBackground, dimention: 4, cellSpacing: 20)
        let gameField = GameFieldView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.width), configuration: gameFieldConfig)
        gameField.center = view.center
        view.addSubview(gameField)
    }


}

