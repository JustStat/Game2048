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
}
