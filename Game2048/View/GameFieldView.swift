//
//  GameFieldView.swift
//  Game2048
//
//  Created by Kirill Varlamov on 09/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import UIKit

protocol GameFieldViewDelegate: class {
    func userDidSwipe(direction: UISwipeGestureRecognizer.Direction)
}

class GameFieldView: UIView {
    
    var dimention: Int
    var cellSpacing : CGFloat
    var cellSize: CGFloat
    var cells: Dictionary<IndexPath, BackgroundCellView>
    
    weak var delegate: GameFieldViewDelegate?
    
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
                let cellView = BackgroundCellView()
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
    func upCommand(_ r: UISwipeGestureRecognizer!) {
        delegate?.userDidSwipe(direction: r.direction)
    }
    
    @objc(down:)
    func downCommand(_ r: UISwipeGestureRecognizer!) {
        delegate?.userDidSwipe(direction: r.direction)
    }
    
    @objc(left:)
    func leftCommand(_ r: UISwipeGestureRecognizer!) {
        delegate?.userDidSwipe(direction: r.direction)
    }
    
    @objc(right:)
    func rightCommand(_ r: UISwipeGestureRecognizer!) {
        delegate?.userDidSwipe(direction: r.direction)
    }
    
    func addCellToGameBoard(path: IndexPath, cell: CellModel) {
        guard let backgroundView = cells[path] else {
            fatalError("cell out of bounds")
        }
        
        let cell = GameCellView(frame: backgroundView.frame, number:cell.value)
        backgroundView.cell = cell
        addSubview(cell)
        UIView.animate(withDuration: 0.10, delay: 0, options: UIView.AnimationOptions(),
                       animations: {
                        cell.layer.setAffineTransform(CGAffineTransform(scaleX: 1.1, y: 1.1))
        },
                       completion: { finished in
                        UIView.animate(withDuration: 0.05, animations: { () -> Void in
                            cell.layer.setAffineTransform(CGAffineTransform.identity)
                        })
        })
    }
    
    func removeCell(forPath path: IndexPath) {
        cells[path]?.cell?.removeFromSuperview()
        cells[path]?.cell = nil
    }
    
    func moveCell(cell: CellModel, from start:IndexPath, to end:IndexPath) {
        guard let startView = cells[start], let endView = cells[end] else {
            return
        }
        
        endView.cell = startView.cell
        UIView.animate(withDuration: 0.2) {
            startView.cell?.frame = endView.frame
        }
    }
}
