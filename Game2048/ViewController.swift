//
//  ViewController.swift
//  Game2048
//
//  Created by Kirill Varlamov on 09/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var gameField: GameFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .background
        let gameFieldConfig = GameFieldConfiguration(backgroundColor: .background, cellColor: .cellBackground, dimention: 4, cellSpacing: 20)
        gameField = GameFieldView(frame:.zero, configuration: gameFieldConfig)
        gameField.center = view.center
        view.addSubview(gameField)
    }
    
    override func viewWillLayoutSubviews() {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            gameField.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.width)
        case .landscapeLeft, .landscapeRight:
            gameField.frame = CGRect(x: 0, y: 0, width: view.bounds.size.height, height: view.bounds.size.height)
        default:
            gameField.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.width)
        }
        gameField.center = view.center
    }
}

