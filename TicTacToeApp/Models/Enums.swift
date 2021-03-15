//
//  Enums.swift
//  TicTacToeApp
//
//  Created by Porter McGary & Joshua Bee on 3/11/21.
//

import Foundation

/// keep track of each individual boxes state
enum BoxState {
    case empty
    case x
    case o
}

enum PlayerMode {
    case single
    case multi
    case none
}

enum Levels: String, CaseIterable, Identifiable {
    case easy
    case medium
    case hard
    case random

    var id: String {self.rawValue}
}
