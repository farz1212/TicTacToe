//
//  GameViewModel.swift
//  TikTacToe
//
//  Created by Farzaad Goiporia on 2024-07-09.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    @Published var humanScore: Int = 0
    @Published var computerScore: Int = 0
    
    //Functions
    func processPlayerMove(for index: Int){
        if isSquareOccupied(in: moves, forindex: index){return}
        moves[index] = Move(player: .human, boardIndex: index)
        
        if checkWinCondition(for: .human, in: moves){
            humanScore += 1
            alertItem = AlertContext.humanWin
            return
        }
        if checkDrawCondition(in: moves){
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves){
                computerScore += 1
                alertItem = AlertContext.ComputerWin
                return
            }
            if checkDrawCondition(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forindex index: Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int{
        
        //If AI can win then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let computerMoves = moves.compactMap{ $0 }.filter{ $0.player == .computer}
        let computerPositions = Set(computerMoves.map{ $0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forindex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        //If AI Can Not Win Then Bloack
        let humanMoves = moves.compactMap{ $0 }.filter{ $0.player == .human}
        let humanPositions = Set(humanMoves.map{ $0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forindex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        //If AI Can Not Bloack Take Middle
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forindex: centerSquare){
            return centerSquare
        }
        
        //Take random Position
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forindex: movePosition)
        {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player}
        let playerPositions = Set(playerMoves.map{ $0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }

    func checkDrawCondition(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }

    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
    
    //Enums and Subviews
    enum Player{
        case human, computer
    }

    struct Move{
        let player: Player
        let boardIndex: Int
        var indicator: String{
            return player == .human ? "xmark" : "circle"
        }
    }

    struct GameCircleView: View {
        var proxy: GeometryProxy
        var body: some View {
            Circle()
                .foregroundColor(Color(hue: 0.7, saturation: 1.0, brightness: 0.6))
                .frame(width: proxy.size.width/3 - 10,
                       height: proxy.size.width/3 - 10)
        }
    }

    struct PlayerIndicator: View {
        var systemImageName: String
        var body: some View {
            Image(systemName: systemImageName)
                .resizable()
                .padding(30)
                .foregroundColor(.white)
        }
    }
}
