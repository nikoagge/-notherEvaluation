//
//  ChessBoardService.swift
//  EvaluationProject
//
//  Created by Nikolas on 1/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import UIKit


protocol ChessBoardDelegate {
    
    
    func boardUpdated()
    func gameOver(withWinner winner: UIColor)
    func gameTied()
    func promotePawn(forPawn pawn: ChessPiece)
}
