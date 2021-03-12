//
//  SwiftUIView.swift
//  TicTacToeApp
//
//  Created by Porter McGary & Joshua Bee on 3/11/21.
//

import SwiftUI

/// This is the board
struct TicTacToeBoard: View {
    /// current board
    var board: Array<BoxState>
    /// call back function when there is a tap
    let callback : (Int) -> Void
    
    var body: some View {
        /// three rows of three
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0...2, id: \.self) { i in
                    Row(box: board[i], index: i, callback: callback)
                }
            }
            HStack(spacing: 0) {
                ForEach(3...5, id: \.self) { i in
                    Row(box: board[i], index: i, callback: callback)
                }
            }
            HStack(spacing: 0) {
                ForEach(6...8, id: \.self) { i in
                    Row(box: board[i], index: i, callback: callback)
                }
            }
        }.background(Color.black)
    }
}

/// Going to get rid of the preview.... to run on Content View
//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        TicTacToeBoard(board: Array<BoxState>(repeating: BoxState.empty, count: 9), callback: takeTurn)
//    }
//
//    func takeTurn(id: Int) {
//
//    }
//}

/// create a row
struct Row: View {
    var box: BoxState
    let index: Int
    let callback: (Int) -> Void
    var body: some View {
        switch box {
            case BoxState.empty:
                Box(id: index, string: " ", callback: callback)
            case BoxState.x:
                Box(id: index, string: "X", callback: callback)
            case BoxState.o:
                Box(id: index, string: "O", callback: callback)
        }
    }
}

/// create an individual box
struct Box: View {
    let id: Int
    let string: String
    let callback: (Int) -> Void
    var body: some View {
        Text(string)
            .onTapGesture(perform: {callback(id)})
            .font(.title)
            .frame(width: 35, height: 35)
            .padding()
            .foregroundColor(.white)
            .border(Color.white, width: 1)
            
    }
}
