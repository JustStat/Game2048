//
//  CellModel.swift
//  Game2048
//
//  Created by Kirill Varlamov on 11/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

enum CellState: Int, Codable {
    case empty
    case filled
    case collision
}

struct CellModel: Codable {
    var state = CellState.empty
    var value = 0
}
