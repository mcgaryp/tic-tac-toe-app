//
//  SwiftUIView.swift
//  TicTacToeApp
//
//  Created by Porter McGary on 3/14/21.
//

import SwiftUI

struct StartView: View {
    @State private var singlePlayerMode: Bool = false
    @State private var twoPlayerMode: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Tic-Tac-Toe")
                    .padding()
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                if !singlePlayerMode && !twoPlayerMode {
                    Button(action: toggleSingle, label: {
                        Text("Single Player")
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    })
                        .padding()
                    
                    Button(action: toggleTwo, label: {
                        Text("Two Player")
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    })
                        .padding()
                }
                
                if singlePlayerMode {
                    SinglePlayer()
                }
                
                if twoPlayerMode {
                    TwoPlayer()
                }
                Spacer()
            }
        }
    }
    func toggleSingle() {
        singlePlayerMode.toggle()
    }
    
    func toggleTwo() {
        twoPlayerMode.toggle()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
