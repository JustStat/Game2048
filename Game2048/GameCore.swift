//
//  GameCore.swift
//  Game2048
//
//  Created by Kirill Varlamov on 11/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import UIKit

protocol GameCoreDelegate: class {
    func modelDidAddCellToGameBoard(path: IndexPath, cell: CellModel)
    func modelDidRemoveCell(path: IndexPath)
    func modelDidMoveCell(cell: CellModel, from start:IndexPath, to end:IndexPath)
    func modelDidFinishMove()
}

class GameCore {
    var gameField: [[CellModel]]
    var emptyCells = [IndexPath]()
    var dimention: Int
    weak var delegate: GameCoreDelegate?
    
    init(dimention: Int) {
        self.dimention = dimention
        gameField = Array(repeating: Array(repeating: CellModel(), count: dimention), count: dimention)
        for i in 0..<dimention {
            for j in 0..<dimention {
                emptyCells.append(IndexPath(row: i, section: j))
            }
        }
    }
    
    func proceedMove(direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .up:
            for i in 0..<dimention {
                for j in 0..<dimention {
                    if gameField[j][i].state != .empty {
                        let index = findApropriateVerticlaIndexes(forIndex: IndexPath(row: j, section: i)).min { (p1, p2) -> Bool in
                            p1.section < p2.section
                        }
                        if index != nil && index!.section < i {
                            moveCell(from: IndexPath(row: j, section: i), to: IndexPath(row: index!.row, section: index!.section))
                        }
                        checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j, section: i - 1))
                        
                    }
                }
            }
        case .down:
            for i in (0..<dimention).reversed() {
                for j in (0..<dimention).reversed() {
                    if gameField[j][i].state != .empty {
                        let index = findApropriateVerticlaIndexes(forIndex: IndexPath(row: j, section: i)).max { (p1, p2) -> Bool in
                            p1.section < p2.section
                        }
                        
                        if index != nil && index!.section > i {
                            moveCell(from: IndexPath(row: j, section: i), to: IndexPath(row: index!.row, section: index!.section))
                        }
                        checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j, section: i + 1))
                        
                    }
                }
        }
        case .right:
                    for i in (0..<dimention).reversed() {
                        for j in (0..<dimention).reversed() {
                            if gameField[j][i].state != .empty {
                                let index = findApropriateHorisontalIndexes(forIndex: IndexPath(row: j, section: i)).max { (p1, p2) -> Bool in
                                    p1.row < p2.row
                                }
                                
                                if index != nil && index!.row > j {
                                    moveCell(from: IndexPath(row: j, section: i), to: IndexPath(row: index!.row, section: index!.section))
                                }
                                checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j + 1, section: i))
                                
                            }
                        }
                }
        case .left:
                            for i in 0..<dimention {
                                for j in 0..<dimention {
                                    if gameField[j][i].state != .empty {
                                        let index = findApropriateHorisontalIndexes(forIndex: IndexPath(row: j, section: i)).min { (p1, p2) -> Bool in
                                            p1.row < p2.row
                                        }
                    
                                        if index != nil && index!.row < j  {
                                            moveCell(from: IndexPath(row: j, section: i), to: IndexPath(row: index!.row, section: index!.section))
                                        }
                                        checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j - 1, section: i))
                                    }
                                }
                        }
        default:
            return
        }
        delegate?.modelDidFinishMove()
    }
    
    func findApropriateVerticlaIndexes(forIndex source: IndexPath) -> [IndexPath] {
        var indexes = [IndexPath]()
        for index in emptyCells {
            if index.row == source.row {
                indexes.append(index)
            }
        }
        
        return indexes.sorted()
    }
    
    func findApropriateHorisontalIndexes(forIndex source: IndexPath) -> [IndexPath] {
        var indexes = [IndexPath]()
        for index in emptyCells {
            if index.section == source.section {
                indexes.append(index)
            }
        }
        
        return indexes.sorted()
    }
    
    func addCellToGameBoard(path: IndexPath, value: Int) {
        gameField[path.row][path.section].state = .filled
        gameField[path.row][path.section].value = value
        emptyCells.remove(at: emptyCells.firstIndex(of: path)!)
        
        delegate?.modelDidAddCellToGameBoard(path: path, cell: gameField[path.row][path.section])
    }
    
    func addCellToRandomPath(value: Int) {
        guard let path = emptyCells.randomElement() else {
            return
            //TODO: endgame
        }
        print("add - \(path)")
        addCellToGameBoard(path: path, value: value)
        
        if let index = emptyCells.firstIndex(of: path) {
            emptyCells.remove(at: index)
        }

    }
    
    func removeCell(fromPath path: IndexPath) {
        gameField[path.row][path.section].state = .empty
        gameField[path.row][path.section].value = 0
        emptyCells.append(path)
        print("remove - \(path)")
        delegate?.modelDidRemoveCell(path: path)
    }
    
    func moveCell(from start:IndexPath, to end:IndexPath) {
        guard 0..<dimention ~= end.row else {
            return
        }
        
        guard 0..<dimention ~= end.section else {
            return
        }
        
        let cell = gameField[start.row][start.section]
        if gameField[end.row][end.section].state == .empty {
            gameField[end.row][end.section] = cell
            gameField[start.row][start.section].state = .empty
            gameField[start.row][start.section].value = 0
            emptyCells.remove(at: emptyCells.firstIndex(of: end)!)
            emptyCells.append(start)
            delegate?.modelDidMoveCell(cell: cell, from: start, to: end)
            print("move - \(start), \(end)")
        }
    }
    
    func checkCollision(from start:IndexPath, to end:IndexPath) {
        guard 0..<dimention ~= end.row else {
            return
        }
        
        guard 0..<dimention ~= end.section else {
            return
        }
        
        if gameField[start.row][start.section].value == gameField[end.row][end.section].value && gameField[end.row][end.section].value > 0 {
            let cell = gameField[end.row][end.section]
            removeCell(fromPath: start)
            removeCell(fromPath: end)
            addCellToGameBoard(path: end, value: cell.value*2)
        }
    }
}
