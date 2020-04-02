//
//  BoardCellService.swift
//  EvaluationProject
//
//  Created by Nikolas on 31/3/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


protocol BoardCellDelegate {
    
    
    func didSelect(forCell cell: BoardCell, atRow row: Int, andColumn column: Int)
}
