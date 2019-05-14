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
    var gameModel = GameCore(dimention: dimention)
    var cooldownTimer: Timer?
    var cooldown: Bool = false
    var wasRestored = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGameField()
        setupRestartButton()
        view.layoutIfNeeded()
        gameModel.delegate = self
        gameField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !wasRestored {
            gameModel.addCellToRandomPath(value: arc4random_uniform(10) == 1 ? 4 : 2)
            gameModel.addCellToRandomPath(value: arc4random_uniform(10) == 1 ? 4 : 2)
        }
    }
    
    func setupView() {
        view.backgroundColor = .background
    }
    
    func setupGameField() {
        let gameFieldConfig = GameFieldConfiguration(backgroundColor: .background, cellColor: .cellBackground, dimention: dimention, cellSpacing: 20)
        gameField = GameFieldView(frame:.zero, configuration: gameFieldConfig)
        gameField.center = view.center
        view.addSubview(gameField)
    }
    
    func setupRestartButton() {
        let restartButton = UIButton(frame: CGRect(origin: CGPoint(x: view.center.x - 105, y: view.bounds.height - 60), size: CGSize(width: 210, height: 40)))
        restartButton.backgroundColor = .white
        
        let attributes: Dictionary<NSAttributedString.Key, Any>  = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
        NSAttributedString.Key.strokeColor : UIColor.black]
        let text = NSAttributedString(string: "Попробовать ещё раз", attributes: attributes)
        restartButton.setAttributedTitle(text, for: .normal)
        restartButton.layer.cornerRadius = 12
        restartButton.addTarget(self, action: #selector(self.restartButtonTap(sender:)), for: .touchUpInside)
        
        restartButton.layer.shadowColor = UIColor.restartButtonShadow.cgColor
        restartButton.layer.shadowOpacity = 1
        restartButton.layer.shadowPath = UIBezierPath(rect: CGRect(x: -1, y: -1, width: restartButton.frame.width + 2, height: restartButton.frame.height + 21)).cgPath
        restartButton.layer.shadowRadius = 10
        
        view.addSubview(restartButton)
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
    
    func showGameOver(userWin: Bool) {
        let title = userWin ? "Ура!" : "Пичалька("
        let message = userWin ? "Вы победили!" : "Игра окончена"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Попробовать еще раз", style: .default) { (action) in
            self.gameModel.restat()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
            if self.gameModel.hasChanges {
                self.gameModel.addCellToRandomPath(value: arc4random_uniform(10) == 1 ? 4 : 2)
            }
            if self.gameModel.checkGameover() {
                self.showGameOver(userWin: false)
            }
        }
    }
    
    func modelGameover(userWin: Bool) {
        showGameOver(userWin: userWin)
    }
    
    func userDidSwipe(direction: UISwipeGestureRecognizer.Direction) {
        if cooldown {
            return
        }
        
        gameModel.proceedMove(direction: direction)
        cooldownTimer = Timer.scheduledTimer(timeInterval: 0.22, target: self, selector: #selector(self.timerHandler(sender:)), userInfo: nil, repeats: false)
        cooldown = true
    }
    @objc(timerHandler:)
    func timerHandler(sender: Timer) {
        cooldown = false
    }
    
    @objc(restartButtonTap:)
    func restartButtonTap(sender: UIButton) {
        gameModel.restat()
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        coder.encode(gameModel, forKey: "gameModel")
        coder.encode(gameField, forKey: "gameField")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        guard let gameModel = coder.decodeObject(forKey: "gameModel") as? GameCore else {
            return
        }
        self.gameModel = gameModel
        self.gameModel.delegate = self
        self.gameModel.restoreState()
        self.wasRestored = true
    }
}



