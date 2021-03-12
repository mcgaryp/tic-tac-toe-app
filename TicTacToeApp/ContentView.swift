//
//  ContentView.swift
//  TicTacToeApp
//
//  Created by Porter McGary on 3/11/21.
//

import SwiftUI

struct ContentView: View {
    @State private var board: Array<BoxState> = Array(repeating: BoxState.empty, count: 9)
    @State private var whoseTurn: Bool = true
    @State private var scores: Array<Int> = Array(repeating: 0, count: 2)
    @State private var turnCount: Int = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                TicTacToeBoard(board: board, callback: takeTurn)
                Button (action: resetBoard, label: {
                    Text("Reset")
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                        .foregroundColor(.blue)
                        .padding()
                })
                HStack {
                    VStack {
                        Text("Player1")
                            .foregroundColor(.white)
                        Text("\(scores[0])")
                            .foregroundColor(.white)
                    }
                    VStack{
                        Text("Player2")
                            .foregroundColor(.white)
                        Text("\(scores[1])")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    func resetBoard () {
        for index in 0...board.count - 1 {
            board[index] = BoxState.empty
        }
    }
    
    func takeTurn(id: Int) {
        if board[id] != .empty {
            return
        }
        turnCount += 1
        let symbol = whoseTurn ? BoxState.x : BoxState.o
        board[id] = symbol
        whoseTurn.toggle()
        whoWon(id: id)
    }
    
    func whoWon(id: Int) {
//        if turnCount <= 5 {
//            return
//        }
        let boxState = board[id]
        let winnerMap = converter(symbol: boxState)
        print(winnerMap)
        //TODO make array of winning totals
    }

    func checkSurroundings() {
        
       
    }
    
    func converter(symbol: BoxState) -> Int{
        let rev = board.reversed()
        var binary: String = ""
        if symbol == .o {
            for box in rev {
                switch box {
                case .o:
                    binary += "1"
                default:
                    binary += "0"
                }
            }
        }
        
        if symbol == .x {
            for box in rev {
                switch box {
                case .x:
                    binary += "1"
                default:
                    binary += "0"
                }
            }
        }
        // convert to integer
        return Int(strtoul(binary, nil, 2))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
