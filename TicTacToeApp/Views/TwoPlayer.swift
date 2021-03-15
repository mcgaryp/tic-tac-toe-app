//
//  TwoPlayer.swift
//  TicTacToeApp
//
//  Created by Porter McGary on 3/14/21.
//

import SwiftUI

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
    /// Text displayed in the alert at the end of the game
    @State private var winnerText: String = ""
    @State private var touch: Bool = true
    @State private var selectedLevel = Levels.hard.rawValue
    /// The number values that are winners
    private let winners = [7, 56, 73, 84, 146, 273, 292, 448]
    private let stopFromWinning = [5,6,3,40,48,24,320,384,192,68,80,20,17,257,272,65,72,9,130,144,18,260,288,36]
    /// Player 1's name
    private let player1: String = "Player 1"
    /// Player 2's name
    private let player2: String = "Player 2"
    private let cpu : String = "CPU"
    var playerMode: PlayerMode
    

    init(player: PlayerMode) {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        playerMode = player
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()   // black background
            VStack(spacing: 20) {
                /// the board
                TicTacToeBoard(board: board, callback: takeTurn)
                    .allowsHitTesting(touch)
                /// reset buttons
                HStack {
                    Button (action: resetBoard, label: {
                        Text("Reset Board")
                            .frame(width: 110)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                            .foregroundColor(.blue)
                            .padding()
                    })
                    
                    Button (action: resetScores, label: {
                        Text("Reset Scores")
                            .frame(width: 110)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                            .foregroundColor(.blue)
                            .padding()
                    })
                }
                /// players scores
                HStack {
                    VStack {
                        Text(player1)
                            .foregroundColor(.white)
                        Text("\(scores[0])")
                            .foregroundColor(.white)
                    }
                    VStack{
                        Text(playerMode == .single ? cpu : player2)
                            .foregroundColor(.white)
                        Text("\(scores[1])")
                            .foregroundColor(.white)
                    }
                }
                
                if playerMode == .single {
                    VStack(spacing: 8) {
                        Text("Difficulty")
                            .foregroundColor(.white)
                            .font(.title2)
                        HStack {
                            Spacer()
                            Picker("Difficulty", selection: $selectedLevel) {
                                ForEach(Levels.allCases) { level in
                                    Text(level.rawValue.capitalized)
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                            Spacer()
                        }
                    }
                }
            }
            /// notify who won
            .alert(isPresented: $winner, content: {
                Alert(
                    title: Text(winnerText),
                    dismissButton: .cancel(Text("Ok"), action: resetBoard)
                )
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
        let symbol = playerMode == .single ? BoxState.x : whoseTurn ? BoxState.x : BoxState.o
        /// assign the symbol to that square
        board[id] = symbol
        /// Lets see if that was a winning move
        whoWon(id: id)
        /// its now the next players turn
        whoseTurn.toggle()
        
        if !winner {
            if playerMode == .single {
                /// Disable tap gestures
                touch = false
                /// computer takes it's turn after a 1 sec delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    computerTurn()
                    /// switch to users turn
                    whoseTurn.toggle()
                    /// enable tap gestures
                    touch = true
                }
            }
        }
    }
    
    /// find out who wont the game
    func whoWon(id: Int) {
        /// a counter to keep track of when to check for a winner
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
                /// set the winner text
                winnerText = "\(whoseTurn ? player1 : playerMode == .single ? cpu : player2) Won!"
                winner.toggle() /// there is a winner
                addScore()      /// Add to their score
                return
            }
        }
        
        /// if there is a cats game
        if turnCount == 9 {
            catsGame()
        }
    }
    
    /// Changes the view according to a cats game
    func catsGame() {
        winnerText = "The CATS won this time!"
//        winner.toggle()
        resetBoard()
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
    
    /// Reset the players scores
    func resetScores() {
        for i in 0...scores.count - 1 {
            scores[i] = 0
        }
    }
    
    /// Let the computer take it's turn
    func computerTurn() {
        var id:Int = -1
        /// The location if the level is easy
        if selectedLevel == Levels.easy.rawValue {
            id = easyLevel()
//            while true {
//                id = Int.random(in: 0...8)
//                if board[id] == .empty {
//                    break
//                }
//            }
        }
        
        /// The location if the level is medium
        if selectedLevel == Levels.medium.rawValue {
            id = mediumLevel()
        }
        
        /// The location of the level is hard
        if selectedLevel == Levels.hard.rawValue {
            id = hardLevel()
        }
        
        turnCount += 1  /// count the turns
        /// what is the symbol we are placing in the square
        let symbol = BoxState.o
        /// assign the symbol to that square
        board[id] = symbol
        /// Lets see if that was a winning move
        whoWon(id: id)
    }
    
    /// TODO: Function that makes a completely random difficulty
    func randomLevel() -> Int {
        // Randomly choose a level
        
        return -1
    }
    
    /// TODO: Function that makes winning easy
    func easyLevel() -> Int {
        // Guess what place the player would not go to win
        
        return -1
    }
    
    /// TODO: Function that makes winning sort of difficult
    func mediumLevel() -> Int {
        // Guess what the player will do next.
        // half of the time block the player if they can make a winning move
        
        return -1
    }
    
    /// TODO: Function that makes winning difficult
    func hardLevel() -> Int {
        // Guess what the player will do next.
        // If there is a possible move that they player can do to win then block that move by going there
        var id = -1
        let boardState = converter(symbol: BoxState.x)
        for stop in stopFromWinning {
            if stopFromWinning.contains(boardState & stop) {
                print("NEED TO PREVENT WIN")
                // TODO: Find the place to put the O
            }
//            Maybe XOR
//            print("\(boardState) ^ \(winner) = \(boardState ^ winner)")
        }
        while true {
            id = Int.random(in: 0...8)
            if board[id] == .empty {
                break
            }
        }
        return id
    }
}

struct TwoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        TwoPlayer(player: .single)
    }
}
