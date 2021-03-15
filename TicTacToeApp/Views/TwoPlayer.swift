//
//  TwoPlayer.swift
//  TicTacToeApp
//
//  Created by Porter McGary on 3/14/21.
//

import SwiftUI

/// TODO: Add a feature when the game ends in a cats.

struct TwoPlayer: View {
    /// State of the tic-tac-toe-board
    @State private var board: Array<BoxState> = Array(repeating: BoxState.empty, count: 9)
    /// State of whose turn it is
    @State private var whoseTurn: Bool = true
    /// Players scores
    @State private var scores: Array<Int> = Array(repeating: 0, count: 2)
    /// number of turns the players have had since the beginning of the current match
    @State private var turnCount: Int = 0
    /// does the current game have a winner
    @State private var winner: Bool = false
    /// The number values that are winners
    private let winners = [7, 56, 73, 84, 146, 273, 292, 448]
    /// Player 1's name
    private let player1: String = "Player 1"
    /// Player 2's name
    private let player2: String = "Player 2"
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()   // black background
            VStack(spacing: 0) {
                /// the board
                TicTacToeBoard(board: board, callback: takeTurn)
                /// reset button
                Button (action: resetBoard, label: {
                    Text("Reset Board")
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                        .foregroundColor(.blue)
                        .padding()
                })
                /// players scores
                HStack {
                    VStack {
                        Text(player1)
                            .foregroundColor(.white)
                        Text("\(scores[0])")
                            .foregroundColor(.white)
                    }
                    VStack{
                        Text(player2)
                            .foregroundColor(.white)
                        Text("\(scores[1])")
                            .foregroundColor(.white)
                    }
                }
            }
            /// notify who won
            .alert(isPresented: $winner, content: {
                Alert(title: Text("\(whoseTurn ? player2 : player1) Won!"))
            })
        }
    }
    
    /// Reset the board
    func resetBoard () {
        /// reset the board to empty
        for index in 0...board.count - 1 {
            board[index] = BoxState.empty
        }
        /// reset the turn counter to 0
        turnCount = 0
    }
    
    /// take your turn by pressing one of the squares
    func takeTurn(id: Int) {
        /// if the spot is taken don't change it
        if board[id] != .empty {
            return
        }
        turnCount += 1  /// count the turns
        /// what is the symbol we are placing in the square
        let symbol = whoseTurn ? BoxState.x : BoxState.o
        /// assign the symbol to that square
        board[id] = symbol
        /// Lets see if that was a winning move
        whoWon(id: id)
        /// its now the next players turn
        whoseTurn.toggle()
    }
    
    /// find out who wont the game
    /// FIXME: Fix the board when the pattern in 0x0x_x0x0 or x0x0_0x0x. The alert is skipped and the winner gets two points
    func whoWon(id: Int) {
        /// a counter to keep track of when the winner should start to be decided
        if turnCount <= 4 {
            return
        }
        /// lets get the number of the players total moves
        /// boardState represents one player's board positions as binary converted to an integer
        let boardState = converter(symbol: board[id])
        /// compare the number to a number in the list determines if the move was a winning one
        for i in 0...winners.count - 1 {
            ///& to check if there are 3 in a row somewhere
            if boardState & winners[i] == winners[i] {
                winner.toggle() /// there is a winner
                addScore()      /// Add to their score
                resetBoard()    /// reset the board
            }
        }
    }
    
    /// Lets convert the total player moves to a number.
    /// symbol is the last symbol placed on the board
    func converter(symbol: BoxState) -> Int{
        /// here is the start of our binary string
        var binary: String = ""
        /// We calculate the binary string for all the symbols's == to symbol on the board
        /// first reverst the board to get the right binary numbers starting with least significant on the right
        for box in board.reversed() {
            binary += (box == symbol) ? "1" : "0"
        }
        /// convert the string to an int for the & operation later
        let b = Int(binary, radix: 2)!
        return b
    }
    
    /// Add the score of the winner
    func addScore() {
        if whoseTurn {
            scores[0] += 1  /// Add to player 1
        } else {
            scores[1] += 1  /// Add to plater 2
        }
    }
}

struct TwoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        TwoPlayer()
    }
}
