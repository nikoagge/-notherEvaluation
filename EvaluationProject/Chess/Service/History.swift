//
//  History.swift
//  EvaluationProject
//
//  Created by Nikolas on 1/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import Foundation


class History {
    
    
  //Each dictionary will contain "start" and "end" move.
    //Example: moves[0] = ["start": index1, "end": index2]
    var arrayMovesDictionary = [[String: BoardIndex]]()
    
    
    func showHistory() {
        
        for (i, movesDictionary) in arrayMovesDictionary.enumerated() {
            
            let start = movesDictionary["start"]
            let end = movesDictionary["end"]
            print("Showing History:")
            print("Move \(i+1)")
            print("Moved from: \(start?.columnValue.rawValue), \(start?.rowValue.rawValue)")
            print("To: \(end?.columnValue.rawValue), \(end?.rowValue.rawValue)")
        }
    }
    
    
    func moveAsIndices() -> [BoardIndex] {
        
        let indices = [BoardIndex]()
        
        return indices
    }
}
