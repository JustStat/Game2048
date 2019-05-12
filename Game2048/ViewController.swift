//
//  ViewController.swift
//  Game2048
//
//  Created by Kirill Varlamov on 09/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import UIKit

let dimention = 4

class ViewController: UIViewController, GameCoreDelegate, GameFieldViewDelegate {
    
    var gameField: GameFieldView!
    let gameModel = GameCore(dimention: dimention)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.layoutIfNeeded()
        gameModel.delegate = self
        gameField.delegate = self
        gameModel.addCellToGameBoard(path: IndexPath(row: 0, section: 0), value: 4)
        gameModel.addCellToGameBoard(path: IndexPath(row: 1, section: 0), value: 4)
        gameModel.addCellToGameBoard(path: IndexPath(row: 2, section: 0), value: 4)
        gameModel.addCellToGameBoard(path: IndexPath(row: 3, section: 0), value: 4)
//        gameModel.addCellToGameBoard(path: IndexPath(row: 0, section: 2), value: 4)
//        gameModel.addCellToRandomPath(value: arc4random_uniform(10) == 1 ? 4 : 2)
//        gameModel.addCellToRandomPath(value: arc4random_uniform(10) == 1 ? 4 : 2)
    }
    
    func setupView() {
        view.backgroundColor = .background
        let gameFieldConfig = GameFieldConfiguration(backgroundColor: .background, cellColor: .cellBackground, dimention: dimention, cellSpacing: 20)
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
    
    func modelDidAddCellToGameBoard(path: IndexPath, cell: CellModel) {
        gameField.addCellToGameBoard(path: path, cell: cell)
    }
    
    func modelDidRemoveCell(path: IndexPath) {
        gameField.removeCell(forPath: path)
    }
    
    func modelDidMoveCell(cell: CellModel, from start: IndexPath, to end: IndexPath) {
        gameField.moveCell(cell: cell, from: start, to: end)
    }
    
    func modelDidFinishMove() {
//        gameModel.addCellToGameBoard(path: IndexPath(row: 0, section: 3), value: 2)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
            self.gameModel.addCellToRandomPath(value: arc4random_uniform(10) == 1 ? 4 : 2)
        }
    }
    
    func userDidSwipe(direction: UISwipeGestureRecognizer.Direction) {
        gameModel.proceedMove(direction: direction)
    }
}

