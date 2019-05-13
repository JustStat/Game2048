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
    func modelGameover(userWin: Bool)
}

class GameCore {
    private var gameField: [[CellModel]]
    var emptyCells = [IndexPath]()
    private var dimention: Int
    weak var delegate: GameCoreDelegate?
    var hasChanges = false
    
    init(dimention: Int) {
        self.dimention = dimention
        gameField = Array(repeating: Array(repeating: CellModel(), count: dimention), count: dimention)
        for i in 0..<dimention {
            for j in 0..<dimention {
                emptyCells.append(IndexPath(row: i, section: j))
            }
        }
    }
    
    func restat() {
        emptyCells.removeAll()
        for i in 0..<dimention {
            for j in 0..<dimention {
                removeCell(fromPath: IndexPath(row: j, section: i))
            }
        }
        addCellToRandomPath(value: arc4random_uniform(10) == 1 ? 4 : 2)
        addCellToRandomPath(value: arc4random_uniform(10) == 1 ? 4 : 2)
    }
    
    func proceedMove(direction: UISwipeGestureRecognizer.Direction) {
        for i in 0..<dimention {
            for j in 0..<dimention {
                if gameField[j][i].state == .collision {
                   gameField[j][i].state = .filled
                }
            }
        }
        
        hasChanges = false
        switch direction {
        case .up:
            for i in 0..<dimention {
                for j in 0..<dimention {
                    if gameField[j][i].state == .filled  {
                        let index = findAppropriateVerticlaIndexes(forIndex: IndexPath(row: j, section: i)).min { (p1, p2) -> Bool in
                            p1.section < p2.section
                        }
                        if index != nil && index!.section < i {
                            moveCell(from: IndexPath(row: j, section: i), to: IndexPath(row: index!.row, section: index!.section))
                            if checkCollision(from: index!, to: IndexPath(row: index!.row, section: index!.section - 1)) {
                                performCollision(from: index!, to: IndexPath(row: index!.row, section: index!.section - 1))
                            }
                        } else {
                            if checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j, section: i - 1)) {
                                performCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j, section: i - 1))
                            }
                        }
                    }
                }
            }
        case .down:
            for i in (0..<dimention).reversed() {
                for j in (0..<dimention).reversed() {
                    if gameField[j][i].state == .filled {
                        let index = findAppropriateVerticlaIndexes(forIndex: IndexPath(row: j, section: i)).max { (p1, p2) -> Bool in
                            p1.section < p2.section
                        }
                        
                        if index != nil && index!.section > i {
                            moveCell(from: IndexPath(row: j, section: i), to: IndexPath(row: index!.row, section: index!.section))
                            if checkCollision(from: index!, to: IndexPath(row: index!.row, section: index!.section + 1)) {
                                performCollision(from: index!, to: IndexPath(row: index!.row, section: index!.section + 1))
                            }
                        } else {
                            if checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j, section: i + 1)) {
                                performCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j, section: i + 1))
                            }
                        }
                    }
                }
        }
        case .right:
            for i in (0..<dimention).reversed() {
                for j in (0..<dimention).reversed() {
                    if gameField[j][i].state == .filled {
                        let index = findAppropriateHorisontalIndexes(forIndex: IndexPath(row: j, section: i)).max { (p1, p2) -> Bool in
                            p1.row < p2.row
                        }
                        
                        if index != nil && index!.row > j {
                            moveCell(from: IndexPath(row: j, section: i), to: IndexPath(row: index!.row, section: index!.section))
                            if checkCollision(from: index!, to: IndexPath(row: index!.row + 1, section: index!.section)) {
                                performCollision(from: index!, to: IndexPath(row: index!.row + 1, section: index!.section))
                            }
                        } else {
                            if checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j + 1, section: i)) {
                                performCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j + 1, section: i))
                            }
                        }
                    }
                }
            }
        case .left:
            for i in 0..<dimention {
                for j in 0..<dimention {
                    if gameField[j][i].state == .filled {
                        let index = findAppropriateHorisontalIndexes(forIndex: IndexPath(row: j, section: i)).min { (p1, p2) -> Bool in
                            p1.row < p2.row
                        }

                        if index != nil && index!.row < j  {
                            moveCell(from: IndexPath(row: j, section: i), to: IndexPath(row: index!.row, section: index!.section))
                            if checkCollision(from: index!, to: IndexPath(row: index!.row - 1, section: index!.section)) {
                                performCollision(from: index!, to: IndexPath(row: index!.row - 1, section: index!.section))
                            }
                        } else {
                            if checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j - 1, section: i)) {
                                performCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j - 1, section: i))
                            }
                        }
                    }
                }
        }
        default:
            return
        }
        delegate?.modelDidFinishMove()
    }
    
    func findAppropriateVerticlaIndexes(forIndex source: IndexPath) -> [IndexPath] {
        var indexes = [IndexPath]()
        for index in emptyCells {
            if index.row == source.row {
                indexes.append(index)
            }
        }
        
        return indexes.sorted()
    }
    
    func findAppropriateHorisontalIndexes(forIndex source: IndexPath) -> [IndexPath] {
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
        
        if let removePath = emptyCells.firstIndex(of: path) {
            emptyCells.remove(at: removePath)
        }
        
        delegate?.modelDidAddCellToGameBoard(path: path, cell: gameField[path.row][path.section])
    }
    
    func addCellToRandomPath(value: Int) {
        guard let path = emptyCells.randomElement() else {
            delegate?.modelGameover(userWin: false)
            return
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
            hasChanges = true
            print("move - \(start), \(end)")
        }
    }
    
    func performCollision(from start:IndexPath, to end:IndexPath) {
        let cell = gameField[end.row][end.section]
        removeCell(fromPath: start)
        removeCell(fromPath: end)
        addCellToGameBoard(path: end, value: cell.value * 2)
        gameField[end.row][end.section].state = .collision
        hasChanges = true
        if cell.value * 2 == 2048 {
            delegate?.modelGameover(userWin: true)
            hasChanges = false
        }
    }
    
    func checkCollision(from start:IndexPath, to end:IndexPath) -> Bool {
        guard 0..<dimention ~= end.row && 0..<dimention ~= end.section else {
            return false
        }
        
        return gameField[start.row][start.section].value == gameField[end.row][end.section].value && gameField[end.row][end.section].value > 0 && gameField[end.row][end.section].state != .collision
    }
    
    func checkGameover() -> Bool {
        for i in 0..<dimention {
            for j in 0..<dimention {
                if checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j - 1, section: i)) ||
                    (j > 0 && gameField[j - 1][i].state == .empty) {
                    return false
                }
    
                if checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j + 1, section: i)) ||
                    (j < dimention - 1 && gameField[j + 1][i].state == .empty) {
                    return false
                }
                if checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j, section: i + 1)) ||
                    (i < dimention - 1 && gameField[j][i + 1].state == .empty) {
                    return false
                }
                if checkCollision(from: IndexPath(row: j, section: i), to: IndexPath(row: j, section: i - 1)) ||
                    (i > 0 && gameField[j][i - 1].state == .empty) {
                    return false
                }
            }
        }
        
        return true
    }
}
