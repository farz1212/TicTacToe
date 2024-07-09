//
//  GameView.swift
//  TikTacToe
//
//  Created by Farzaad Goiporia on 2024-07-08.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Text("Tic-Tac-Toe")
                    .font(.system(size: geometry.size.width/8))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: Color(hue: 0.7, saturation: 1.0, brightness: 0.6), radius: 2, y:5)
                
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9){ index in
                        ZStack{
                            GameViewModel.GameCircleView(proxy: geometry)
                            GameViewModel.PlayerIndicator(systemImageName: viewModel.moves[index]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: index)
                        }
                    }
                }
                Spacer()
                VStack(spacing: 10){
                    Text("Score")
                        .font(.system(size: 30))
                    
                    Divider()
                        .frame(height: 2)
                        .background(.white)
                    
                    HStack(){
                        Spacer()
                        Text(String(viewModel.humanScore))
                            .foregroundColor(.green)
                        Spacer()
                        Text(String(viewModel.computerScore))
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .font(.system(size: 50))
                    
                }
                .foregroundColor(.white)
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .disabled(viewModel.isGameBoardDisabled)
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
        })
    }
}

#Preview {
    GameView()
}
