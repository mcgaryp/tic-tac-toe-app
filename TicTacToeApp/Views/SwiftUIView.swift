//
//  SwiftUIView.swift
//  TicTacToeApp
//
//  Created by Porter McGary on 3/11/21.
//

import SwiftUI

struct TicTacToeBoard: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 100, y: 0))
            path.addLine(to: CGPoint(x: 100 , y: 300))
        }
        .stroke(Color.black, lineWidth: 3)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TicTacToeBoard()
    }
}
