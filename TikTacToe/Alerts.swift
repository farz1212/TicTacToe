//
//  Alerts.swift
//  TikTacToe
//
//  Created by Farzaad Goiporia on 2024-07-09.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext{
    static let humanWin    = AlertItem(title: Text("You Win"),
                                       message: Text("You are the smartest human ever"),
                                       buttonTitle: Text("Claim Victory"))
    static let ComputerWin = AlertItem(title: Text("You Lost"),
                                       message: Text("The AI was too smart for your tiny brain"),
                                       buttonTitle: Text("Accept Defeat"))
    static let draw        = AlertItem(title: Text("Draw"),
                                       message: Text("You have finally met your match"),
                                       buttonTitle: Text("Keep trying"))
}
