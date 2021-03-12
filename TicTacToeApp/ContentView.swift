//
//  ContentView.swift
//  TicTacToeApp
//
//  Created by Porter McGary on 3/11/21.
//

import SwiftUI

struct ContentView: View {
    @State private var board: Array<BoxState> = Array(repeating: BoxState.x, count: 9)
    @State private var whoseTurn: Bool = true
    
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
            }
        }
    }
    
    func resetBoard () {
        for index in 0...board.count - 1 {
            board[index] = BoxState.empty
        }
    }
    
    func takeTurn(id: Int) {
        let symbol = whoseTurn ? BoxState.x : BoxState.o
        board[id] = symbol
        whoseTurn.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
