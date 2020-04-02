//
//  ChessPiece.swift
//  EvaluationProject
//
//  Created by Nikolas on 1/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import UIKit


enum PieceType {
    
    case pawn
    case rook
    case knight
    case bishop
    case queen
    case king
    case dummy
}


class ChessPiece {
    
    var row: Int = 0 {
        
        didSet {
            
            updateIndex()
        }
    }
    
    var col: Int = 0 {
        
        didSet {
            
            updateIndex()
        }
    }
    
    var boardIndex: BoardIndex
    var symbol: String
    var color: UIColor
    var type: PieceType
    var advancingByTwo = false //only available for pawn type
    var firstMove = true //only available for king type
    var playerColor: UIColor
    
    
    init(withRow row: Int, withColumn column: Int, withColor color: UIColor, withPieceType pieceType: PieceType, forPlayerColor playerColor: UIColor) {
        
        self.row = row
        self.col = column
        self.boardIndex = BoardIndex(forRow: row, forColumn: col)
        self.color = playerColor
        self.type = pieceType
        self.symbol = ""
        self.playerColor = playerColor
        
        setupSymbol()
    }
    
    
    func updateIndex() {
        
        let boardDirection: BoardDirection = playerColor == .white ? .bottom : .top
        
        boardIndex.updateValue(fromBoardDirection: boardDirection)
    }
    
    
    func showPieceInfo() {
        
        print("Piece:")
        print("Value row: \(boardIndex.rowValue.rawValue)")
        print("Value column: \(boardIndex.columnValue.rawValue)")
    }
    
    
    private func setupSymbol() {
        
        switch type {
            
        case .pawn:
            symbol = "♟"
            
        case .rook:
            symbol = "♜"
            
        case .knight:
            symbol = "♞"
            
        case .bishop:
            symbol = "♝"
            
        case .king:
            symbol = "♚"
            
        case .queen:
            symbol = "♛"
            
        case .dummy:
            symbol = ""
        }
    }
    
    
    //Checks to see if the direction the piece is moving is the way this piece type is allowed to move. Doesn't take into account the state of the board.
    func isMovementAppropriate(toBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        switch type {
            
        case .pawn:
            return checkPawn(forBoardIndexDestination: boardIndexDestination)
            
        case .rook:
            return checkRook(forBoardIndexDestination: boardIndexDestination)
            
        case .knight:
            return checkKnight(forBoardIndexDestination: boardIndexDestination)
            
        case .bishop:
            return checkBishop(forBoardIndexDestination: boardIndexDestination)
            
        case .queen:
            return checkQueen(forBoardIndexDestination: boardIndexDestination)
            
        case .king:
            return checkKing(forBoardIndexDestination: boardIndexDestination)
            
        case .dummy:
            return false
        }
    }
    
    
    private func checkPawn(forBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        //Is it advancing by 2. Check if the move is in the same column.
        if self.col == boardIndexDestination.column {
            
            //Can only move 2 forward if first time moving pawn.
            if color != playerColor {
                
                if row == 1 && boardIndexDestination.row == 3 {
                    
                    advancingByTwo = true
                    
                    return true
                }
            } else {
                
                if row == 6 && boardIndexDestination.row == 4 {
                    
                    advancingByTwo = true
                    
                    return true
                }
            }
        }
        
        advancingByTwo = false
        
        //The move direction depends on the color of the piece.
        var moveDirection: Int
        
        if color == playerColor {
            
            moveDirection = -1
        } else {
            
            moveDirection = 1
        }
        
        if boardIndexDestination.row == self.row + moveDirection {
            
            //Check for diagonal movement and forward movement.
            if (boardIndexDestination.column == self.col - 1) || (boardIndexDestination.column == self.col) || (boardIndexDestination.column == self.col + 1) {
                
                return true
            }
        }
        
        return false
    }
    
    
    private func checkRook(forBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        if self.row == boardIndexDestination.row || self.col == boardIndexDestination.column {
            
            return true
        }
        
        return false
    }
    
    
    private func checkKnight(forBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        let validMoves = [(self.row - 1, self.col + 2), (self.row - 2, self.col + 1), (self.row - 2, self.col - 1), (self.row - 1, self.col - 2), (self.row + 1, self.col - 2), (self.row + 2, self.col - 1), (self.row + 2, self.col + 1), (self.row + 1, self.col + 2)]
        
        for (validRow, validColumn) in validMoves {
            
            if boardIndexDestination.row == validRow && boardIndexDestination.column == validColumn {
                
                return true
            }
        }
        
        return false
    }
    
    
    private func checkBishop(forBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        if abs(boardIndexDestination.row - self.row) == abs(boardIndexDestination.column - self.col) {
            
            return true
        }
        
        return false
    }
    
    
    private func checkQueen(forBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        //Check diagonal move
        if abs(boardIndexDestination.row - self.row) == abs(boardIndexDestination.column - self.col) {
            
            return true
        }
        
        //Check rook-like move
        if self.row == boardIndexDestination.row || self.col == boardIndexDestination.column {
            
            return true
        }
        
        return false
    }
    
    
    private func checkKing(forBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        //King only moves one space at a time
        let deltaRow = abs(self.row - boardIndexDestination.row)
        let deltaColumn = abs(self.col - boardIndexDestination.column)
        
        if (deltaRow == 0 || deltaRow == 1) && (deltaColumn == 0 || deltaColumn == 1) {
            
            return true
        }
        
        if firstMove {
            
            if deltaRow == 0 && deltaColumn == 2 {
                
                return true
            }
        }
        
        return false
    }
    
    
    func printInfo() -> String {
        
        var printColor = "Clear"
        
        if color == .white {
            
            printColor = "White"
        } else if color == .black {
            
            printColor = "Black"
        }
        
        return "\(printColor) \(symbol)"
    }
}
