//
//  SwiftUIView.swift
//  TicTacToeApp
//
//  Created by Porter McGary on 3/14/21.
//

import SwiftUI

struct StartView: View {
    @State private var playerMode: PlayerMode = PlayerMode.none
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                ZStack {
                    if playerMode != .none {
                        HStack {
                            Button(action: toggleNone, label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(.white)
                                    .font(Font.system(.title))
                                    .padding()
                            })
                            Spacer()
                        }
                    }
                    Text("Tic-Tac-Toe")
                        .padding()
                        .font(.title)
                        .foregroundColor(.white)
                }
                Spacer()
                if playerMode == .none {
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
                
                if playerMode == .single{
                    PlayGame(player: playerMode)
                }
                
                if playerMode == .multi {
                    PlayGame(player: playerMode)
                }
                Spacer()
            }
        }
    }
    
    func toggleSingle() {
        playerMode = .single
    }
    
    func toggleTwo() {
        playerMode = .multi
    }
    
    func toggleNone() {
        playerMode = .none
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
