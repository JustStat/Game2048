//
//  GameFieldView.swift
//  Game2048
//
//  Created by Kirill Varlamov on 09/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import UIKit

class GameFieldView: UIView {
    
    var dimention: Int
    var cellSpacing : CGFloat
    var cellSize: CGFloat
    var cells: Dictionary<IndexPath, UIView>
    
    init(frame: CGRect, configuration: GameFieldConfiguration) {
        self.dimention = configuration.dimention
        self.cellSpacing = configuration.cellSpacing
        self.cellSize = abs((frame.width - (CGFloat(dimention + 1) * cellSpacing)) / CGFloat(dimention))
        self.cells = Dictionary()
        super.init(frame: frame)
        addBackgroundCells()
        addGestures()
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            self.cellSize = abs((frame.width - (CGFloat(dimention + 1) * cellSpacing)) / CGFloat(dimention))
        }
    }
    
    private func addBackgroundCells() {
        for i in 0..<dimention {
            for j in 0..<dimention {
                let cellView = UIView()
                cellView.backgroundColor = .cellBackground
                cellView.layer.cornerRadius = 12
                cellView.clipsToBounds = true
                cells[IndexPath(row: j, section: i)] = cellView
                addSubview(cellView)
            }
        }
    }
    
    override func layoutSubviews() {
        var curPoint = CGPoint(x: cellSpacing, y: cellSpacing)
        for i in 0..<dimention {
            for j in 0..<dimention {
                let curCell = cells[IndexPath(row: j, section: i)]!
                curCell.frame = CGRect(x: curPoint.x, y: curPoint.y, width: cellSize, height: cellSize)
                curPoint.x += cellSpacing + cellSize
            }
            curPoint.y += cellSpacing + cellSize
            curPoint.x = cellSpacing
        }
    }
    
    private func addGestures() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameFieldView.upCommand(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = .up
        addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameFieldView.downCommand(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = .down
        addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameFieldView.leftCommand(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameFieldView.rightCommand(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
    }
    
    @objc(up:)
    func upCommand(_ r: UIGestureRecognizer!) {
        addRandomCell()
    }
    
    @objc(down:)
    func downCommand(_ r: UIGestureRecognizer!) {
        addRandomCell()
    }
    
    @objc(left:)
    func leftCommand(_ r: UIGestureRecognizer!) {
        addRandomCell()
    }
    
    @objc(right:)
    func rightCommand(_ r: UIGestureRecognizer!) {
        addRandomCell()
    }
    
    private func addRandomCell() {
        let bc = cells[IndexPath(row: Int.random(in: 0...3), section: Int.random(in: 0...3))]!
        var stage = Int.random(in: 1...11)
        stage = Int(truncating: NSDecimalNumber(decimal: pow(2, stage)))
        let cell = GameCell(frame: CGRect(origin: .zero, size: bc.frame.size), number:stage)
        bc.addSubview(cell)
    }
}
