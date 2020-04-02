//
//  BoardIndex.swift
//  EvaluationProject
//
//  Created by Nikolas on 31/3/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import UIKit


enum BoardHorizontal: String {
    
    
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h
}


enum BoardVertical: Int {
    
    
    case one = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
}


enum BoardDirection {
    
    
    case top
    case bottom
}


class BoardIndex: Equatable {
    
    
    var row: Int!
    var column: Int!
    var rowValue: BoardVertical!
    var columnValue: BoardHorizontal!
    
    
    init(forRow row: Int, forColumn column: Int) {
        
        self.row = row
        self.column = column
        
        updateValue(fromBoardDirection: .top)
    }
    
    
    func updateValue(fromBoardDirection boardDirection: BoardDirection) {
        
        if boardDirection == .bottom {
            
            switch row {
                
            case 0:
                rowValue = .one
                
            case 1:
                rowValue = .two
                
            case 2:
                rowValue = .three
                
            case 3:
                rowValue = .four
                
            case 4:
                rowValue = .five
                
            case 5:
                rowValue = .six
                
            case 6:
                rowValue = .seven
                
            case 7:
                rowValue = .eight
            
            default:
                print("You shouldn't be here!")
                rowValue = .eight
            }
            
            switch column {
                
            case 0:
                columnValue = .a
                
            case 1:
                columnValue = .b
                
            case 2:
                columnValue = .c
                
            case 3:
                columnValue = .d
                
            case 4:
                columnValue = .e
                
            case 5:
                columnValue = .f
                
            case 6:
                columnValue = .g
                
            case 7: columnValue = .h
                
            default:
                print("You shouldn't be here!")
                columnValue = .a
            }
        } else if boardDirection == .top {
            
            switch row {
                
            case 0:
                rowValue = .eight
                
            case 1:
                rowValue = .seven
                
            case 2:
                rowValue = .six
                
            case 3:
                rowValue = .five
                
            case 4:
                rowValue = .four
                
            case 5:
                rowValue = .three
                
            case 6:
                rowValue = .two
                
            case 7:
                rowValue = .one
                
            default:
                print("You shouldn't be here!")
                rowValue = .eight
            }
            
            switch column {
                
            case 0:
                columnValue = .a
                
            case 1:
                columnValue = .b
                
            case 2:
                columnValue = .c
                
            case 3:
                columnValue = .d
                
            case 4:
                columnValue = .e
                
            case 5:
                columnValue = .f
                
            case 6:
                columnValue = .g
                
            case 7:
                columnValue = .h
                
            default:
                print("You shouldn't be here!")
                columnValue = .a
            }
        }
    }
    
    
    static func == (lhs: BoardIndex, rhs: BoardIndex) -> Bool {
        
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}
