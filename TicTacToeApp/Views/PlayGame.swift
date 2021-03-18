//
//  TwoPlayer.swift
//  TicTacToeApp
//
//  Created by Porter McGary on 3/14/21.
//

import SwiftUI

struct PlayGame: View {
    /// State of the tic-tac-toe-board
    @State private var board: Array<BoxState> = Array(repeating: BoxState.empty, count: 9)
    /// State of whose turn it is
    @State private var playerTurn: PlayerTurns = PlayerTurns.player1
    /// Players scores
    @State private var scores: Array<Int> = Array(repeating: 0, count: 2)
    /// number of turns the players have had since the beginning of the current match
    @State private var turnCount: Int = 0
    /// does the current game have a winner
    @State private var winner: Bool = false
    /// Text displayed in the alert at the end of the game
    @State private var winnerText: String = ""
    @State private var touch: Bool = true
    @State private var selectedLevel = Levels.medium.rawValue
    @State private var inGame: Bool = false
    /// The number values that are winners
    private let winners = [7, 56, 73, 84, 146, 273, 292, 448]
    private var stopFromWinning = [3, 5, 6, 9, 17, 18, 20, 24, 36, 40, 48, 65, 68, 72, 80, 130, 144, 192, 257, 260, 272, 288, 320, 384]
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
        playerMode = player    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()   // black background
            VStack(spacing: 20) {
                /// players scores
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "person.circle.fill")
                        Text(player1)
                            .foregroundColor(.white)
                        Text("\(scores[0])")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack{
                        Image(systemName: "person.circle.fill")
                        Text(playerMode == .single ? cpu : player2)
                            .foregroundColor(.white)
                        Text("\(scores[1])")
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                
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
                            .foregroundColor(.black)
                            .padding()
                    })
                    
                    Button (action: resetScores, label: {
                        Text("Reset Scores")
                            .frame(width: 110)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                            .padding()
                    })
                }
                
                /// Difficulty
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
                            .disabled(inGame)
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
        inGame = false
    }
    
    /// take your turn by pressing one of the squares
    func takeTurn(id: Int) {
        /// if the spot is taken don't change it
        if board[id] != .empty {
            return
        }
        // If its a new game the user starts first
        if turnCount == 0 {
            playerTurn = .player1
            inGame = true
        }
        
        turnCount += 1  /// count the turns
        /// what is the symbol we are placing in the square
        var symbol = BoxState.empty
        if playerTurn == .player1 {
            symbol = .x
        } else if playerTurn == .player2 {
            symbol = .o
        }
        
        /// assign the symbol to that square
        board[id] = symbol
        /// Lets see if that was a winning move
        whoWon(id: id)
        /// its now the next players turn
        changeTurn()
        
        if !winner {
            if playerMode == .single {
                /// Disable tap gestures
                touch = false
                /// computer takes it's turn after a 1 sec delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    computerTurn()
                    /// switch to users turn
                    
                    if !winner {
                        changeTurn()
                    }
                    /// enable tap gestures
                    touch = true
                }
            }
        }
    }
    
    /// Change the turn of the player
    func changeTurn() {
//        print("PLAYED First: \(playerTurn)")
        if playerTurn == .player1 {
            playerTurn = .player2
        } else if playerTurn == .player2 {
            playerTurn = .player1
        }
//        print("PLAYING Next: \(playerTurn)")
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
                if playerTurn == .player1 {
                    winnerText = player1
                } else if playerTurn == .player2 && playerMode == .single{
                    winnerText = cpu
                } else {
                    winnerText = player2
                }
                winnerText += " Won!"
                winner.toggle() /// there is a winner
                addScore()      /// Add to their score
                return
            }
        }
        
        /// if there is a cats game
        if turnCount == 9 {
            // notify that it was cats
            catsGame()
        }
    }
    
    /// Changes the view according to a cats game
    func catsGame() {
        winnerText = "The CATS won this time!"
        // Notify the game is over
        winner.toggle()
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
        if playerTurn == .player1 {
            scores[0] += 1  /// Add to player 1
        } else if playerTurn == .player2 {
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

        while id < 0 {
            /// The location if the level is easy
            if selectedLevel == Levels.easy.rawValue {
                id = easyLevel()
            }
            
            /// The location if the level is medium
            if selectedLevel == Levels.medium.rawValue {
                id = mediumLevel()
            }
            
            /// The location of the level is hard
            if selectedLevel == Levels.hard.rawValue {
                id = hardLevel()
            }
            
            if id != -1 {
                if board[id] == .empty {
                    /// assign the symbol to that square
                    board[id] = BoxState.o
                } else {
                    id = -1
                }
            }
        }
        
        turnCount += 1  /// count the turns
        
        /// Lets see if that was a winning move
        whoWon(id: id)
    }
    
    /// Function that Plays in a completely random place
    func random() -> Int {
        /// Randomly choose a place to play
        return Int.random(in: 0...8)
    }
    
    /// Function that makes winning easy
    func easyLevel() -> Int {
        /// Guess what the player will do next.
        /// a third the time block the player if they can make a winning move
        let goodMove = hardLevel()
        let randMove = random()
        let chance: Int = Int.random(in: 1...100)
        /// 20% chance of a good move
        if chance < 20 {
            return goodMove
        }
        else {
            return randMove
        }
    }
    
    /// Function that makes winning sort of difficult
    func mediumLevel() -> Int {
        /// Guess what the player will do next.
        /// half of the time block the player if they can make a winning move
        let chance: Int = Int.random(in: 1...10)
        /// 50% chance of a good move
        if chance < 6 {
            return hardLevel()
        }
        return random()
    }
    
    /// Function that makes winning difficult
    func hardLevel() -> Int {
        /// Guess what the player will do next.
        /// If there is a possible move that they player can do to win then block that move by going there
        var id = -1
        
        /// Looking for winning moves
        id = tryToWin()
        
        /// Did I find any?
        if id > -1 {
            return id
        }
        
        /// Look for saving moves
        id = tryToSave()
        
        /// Did I find a spot?
        if id > -1 {
            return id
        }
        
        /// If there is not a strategic place to place the O then go somewhere random
        if id == -1 {
            id = random()
        }
        
        return id
    }
    
    /// Try and find a place to strategically go and win
    func tryToWin() -> Int {
        var id: Int = -1    /// Init the position
        let oState = converter(symbol: .o)
        /// Find where to place the O if we can win
        outerLoop: for play in stopFromWinning {
            /// is this a winning possibility
            if stopFromWinning.contains(oState & play) {
                /// Find where to Place the O to win
                innerLoop: for w in winners {
                    /// does this spot have a chance to win?
                    if (oState | (oState ^ w)) == w {
                        /// convert to the position on the board i want to go
                        id = Int(log2(Double(oState ^ w)))
                        /// Perform winning move
                        if id > -1 {
                            /// Has the spot been taken?
                            if board[id] != .empty {
                                id = -1
                            } else {
                                return id
                            }
                        }
                    }
                }
            }
        }
        return id
    }
    
    /// Try and find a place to strategically go and prevent the user from winning
    func tryToSave() -> Int {
        var id: Int = -1    /// Init id
        let xState = converter(symbol: .x)
        outerLoop: for stop in stopFromWinning {
            /// There is a winning move the player can play next...
            if stopFromWinning.contains(xState & stop) {
                /// Find where to place the O if we need to prevent a win
                innerLoop: for w in winners {
                    /// if the board and the almost win is | with the winning move and it is in the winners group then we need to prevent
                    if winners.contains((xState & stop) | w) {
                        /// convert to position on the game
                        id = Int(log2(Double((xState & stop) ^ w)))
                        if id > -1 {
                            /// if the move is blocked
                            if board[id] != .empty {
                                id = -1
                            } else {
                                /// this is our move
                                return id
                            }
                        }
                    }
                }
            }
        }
        return id
    }
}

struct PlayGame_Previews: PreviewProvider {
    static var previews: some View {
        PlayGame(player: .single)
    }
}

/// To see what was happening with the bits of the board game
extension BinaryInteger {
    var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        var counter = 0

        for _ in (1...self.bitWidth) {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
            counter += 1
            if counter % 4 == 0 {
                binaryString.insert(contentsOf: " ", at: binaryString.startIndex)
            }
        }

        return binaryString
    }
}
