//
//  ChessBoard.swift
//  EvaluationProject
//
//  Created by Nikolas on 1/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import UIKit


class ChessBoard {
    
    
    var chessBoard = [[ChessPiece]]()
    var chessBoardDelegate: ChessBoardDelegate?
    var playerColor: UIColor!
    var history = History()
    
    
    init(withPlayerColor color: UIColor) {
        
        self.playerColor = color
        
        let oneRow = Array(repeating: ChessPiece(withRow: 0, withColumn: 0, withColor: .clear, withPieceType: .dummy, forPlayerColor: color), count: 8)
        
        chessBoard = Array(repeating: oneRow, count: 8)
        
        startNewGame()
    }
    
    
    func startNewGame() {
        
        let opponent: UIColor = playerColor == .white ? .black : .white
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                switch row {
                    
                case 0: //First row of chess board
                    switch column { //determine what piece to put in each column of first row
                    case 0:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .rook, forPlayerColor: playerColor)
                        
                    case 1:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .knight, forPlayerColor: playerColor)
                        
                    case 2:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .bishop, forPlayerColor: playerColor)
                        
                    case 3:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .queen, forPlayerColor: playerColor)
                        
                    case 4:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .king, forPlayerColor: playerColor)
                        
                    case 5:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .bishop, forPlayerColor: playerColor)
                        
                    case 6:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .king, forPlayerColor: playerColor)
                        
                    default:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .rook, forPlayerColor: playerColor)
                    }
                    
                case 1:
                    chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: opponent, withPieceType: .pawn, forPlayerColor: playerColor)
                    
                case 6:
                    chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .pawn, forPlayerColor: playerColor)
                    
                case 7:
                    switch column { //determine what piece to put in each column of first row
                        
                    case 0:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .rook, forPlayerColor: playerColor)
                        
                    case 1:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .knight, forPlayerColor: playerColor)
                        
                    case 2:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .bishop, forPlayerColor: playerColor)
                        
                    case 3:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .queen, forPlayerColor: playerColor)
                        
                    case 4:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .king, forPlayerColor: playerColor)
                        
                    case 5:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .bishop, forPlayerColor: playerColor)
                        
                    case 6:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .knight, forPlayerColor: playerColor)
                        
                    default:
                        chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: playerColor, withPieceType: .rook, forPlayerColor: playerColor)
                    }
                    
                default:
                    chessBoard[row][column] = ChessPiece(withRow: row, withColumn: column, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
                }
            }
        }
        
        chessBoardDelegate?.boardUpdated()
    }
    
    
    func isAttackingOwnChessPiece(forAttackingChessPiece attackingChessPiece: ChessPiece, atBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        let destinationChessPiece = chessBoard[boardIndexDestination.row][boardIndexDestination.column]
        
        guard !(destinationChessPiece.type == .dummy) else {
            
            //atacking an empty cell
            return false
        }
        
        return destinationChessPiece.color == attackingChessPiece.color
    }
    
    
    func getPossibleMoves(forChessPiece chessPiece: ChessPiece) -> [BoardIndex] {
        
        var possibleMoves = [BoardIndex]()
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                let boardIndexDestination = BoardIndex(forRow: row, forColumn: column)
                
                if isMoveLegal(forChessPiece: chessPiece, toBoardIndexDestination: boardIndexDestination, considerOwnPiece: true) {
                    
                    possibleMoves.append(boardIndexDestination)
                }
            }
        }
        
        //Make sure that by making this move, the player is not exposing his king.
        var realPossibleChessMoves = [BoardIndex]()
        
        if chessPiece.type == .king {
            
            for chessMove in possibleMoves {
                
                if !canOpponentAttack(forPlayerKing: chessPiece, ifMovedTo: chessMove) {
                    
                    if chessPiece.firstMove && isMoveTwoCellsOver(forKing: chessPiece, forMove: chessMove) {
                        
                        if isRookNext(toKing: chessPiece, forMove: chessMove) {
                            
                            realPossibleChessMoves.append(chessMove)
                        }
                    } else {
                        
                        realPossibleChessMoves.append(chessMove)
                    }
                }
            }
        } else {
            
            for possibleMove in possibleMoves {
                
                if !doesMoveExposeKingToCheck(forPlayerPiece: chessPiece, toBoardIndexDestination: possibleMove) {
                    
                    realPossibleChessMoves.append(possibleMove)
                }
            }
        }
        
        return realPossibleChessMoves
    }
    
    
    //Makes the given move and checks for gameover/tie and reports back through delegates
    func move(forChessPiece chessPiece: ChessPiece, fromBoardIndexSource boardIndexSource: BoardIndex, toBoardIndexDestination boardIndexDestination: BoardIndex) {
        
        let dictionary = ["start": boardIndexSource, "end": boardIndexDestination]
        history.arrayMovesDictionary.append(dictionary)
        history.showHistory()
        
        if chessPiece.type == .king {
            
            chessPiece.firstMove = false
            
            if isMoveTwoCellsOver(forKing: chessPiece, forMove: boardIndexDestination) {
                
                chessBoard[boardIndexDestination.row][boardIndexDestination.column] = chessPiece
                chessPiece.row = boardIndexDestination.row
                chessPiece.col = boardIndexDestination.column
                
                chessBoard[boardIndexSource.row][boardIndexSource.column] = ChessPiece(withRow: boardIndexSource.row, withColumn: boardIndexSource.column, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
                
                let rook = chessBoard[boardIndexDestination.row][boardIndexDestination.column+1]
                chessBoard[boardIndexDestination.row][boardIndexDestination.column+1] = ChessPiece(withRow: boardIndexDestination.row, withColumn: boardIndexDestination.column+1, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
                rook.row = boardIndexDestination.row
                rook.col = boardIndexDestination.column - 1
                
                chessBoard[boardIndexDestination.row][boardIndexDestination.column-1] = rook
            } else {
                
                chessBoard[boardIndexDestination.row][boardIndexDestination.column] = chessPiece
                chessBoard[boardIndexSource.row][boardIndexSource.column] = ChessPiece(withRow: boardIndexSource.row, withColumn: boardIndexSource.column, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
                chessPiece.row = boardIndexDestination.row
                chessPiece.col = boardIndexDestination.column
            }
        } else {
            
            //Add piece to new location
            chessBoard[boardIndexDestination.row][boardIndexDestination.column] = chessPiece
            
            //Add a dummy piece at old location.
            chessBoard[boardIndexSource.row][boardIndexSource.column] = ChessPiece(withRow: boardIndexSource.row, withColumn: boardIndexSource.column, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
            
            //Update piece's location variables
            chessPiece.row = boardIndexDestination.row
            chessPiece.col = boardIndexDestination.column
        }
        
        if chessPiece.type == .pawn {
            
            if doesPawnNeedPromotion(forPawn: (chessPiece)) {
                
                chessBoardDelegate?.promotePawn(forPawn: chessPiece)
            }
        }
        
        //Check if by making this move, the player has won the game
        if isWinner(forPlayer: chessPiece.color, byMove: boardIndexDestination) {
            
            chessBoardDelegate?.gameOver(withWinner: chessPiece.color)
        } else if isGameTie(withCurrentPlayer: chessPiece.color) {
            
            chessBoardDelegate?.gameTied()
        }
        
        chessBoardDelegate?.boardUpdated()
    }
    
    
    //Move validations per piece type. All move validations start here
    func isMoveLegal(forChessPiece chessPiece: ChessPiece, toBoardIndexDestination boardIndexDestination: BoardIndex, considerOwnPiece consider: Bool) -> Bool {
        
        //When checking if king can take opponent piece while under check by that piece
        if consider {
            
            if isAttackingOwnChessPiece(forAttackingChessPiece: chessPiece, atBoardIndexDestination: boardIndexDestination) {
                
                return false
            }
        }
        
        //Moving on itself
        if chessPiece.col == boardIndexDestination.column && chessPiece.row == boardIndexDestination.row {
            
            return false
        }
        
        switch chessPiece.type {
            
        case .pawn:
            return isMoveValid(forPawn: chessPiece, toBoardIndexDestination: boardIndexDestination)
            
        case .rook, .bishop, .queen:
            return isMoveValid(forRookOrBishopOrQueen: chessPiece, toBoardIndexDestination: boardIndexDestination)
            
        case .knight: //The knight doesn't care about the state of the board because it jumps over pieces. So there is no piece in the way for example.
            if chessPiece.isMovementAppropriate(toBoardIndexDestination: boardIndexDestination) == false {
                
                return false
            }
            
        case .king:
            return isMoveValid(forKing: chessPiece, toBoardIndexDestination: boardIndexDestination)
            
        default:
            break
        }
        
        return true
    }
    
    
    func isMoveValid(forPawn pawn: ChessPiece, toBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        if pawn.isMovementAppropriate(toBoardIndexDestination: boardIndexDestination) == false {
            
            return false
        }
        
        //If it's same column
        if pawn.col == boardIndexDestination.column {
            
            if pawn.advancingByTwo {
                
                var moveDirection: Int
                
                if pawn.color == playerColor {
                    
                    moveDirection = -1
                } else {
                    
                    moveDirection = 1
                }
                
                //Make sure there are no pieces in the way or at destination.
                if chessBoard[boardIndexDestination.row][boardIndexDestination.column].type == .dummy && chessBoard[boardIndexDestination.row - moveDirection][boardIndexDestination.column].type == .dummy {
                    
                    return true
                }
            } else {
                
                if chessBoard[boardIndexDestination.row][boardIndexDestination.column].type == .dummy {
                    
                    return true
                }
            }
        } else { //Attempting to go diagonally. We will check that the destination cell doesn't contain a friend piece before getting to this cell. So just make sure the cell is not empty
            if !(chessBoard[boardIndexDestination.row][boardIndexDestination.column].type == .dummy) {
                
                return true
            }
        }
        
        return false
    }
    
    
    func isMoveValid(forRookOrBishopOrQueen chessPiece: ChessPiece, toBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        if chessPiece.isMovementAppropriate(toBoardIndexDestination: boardIndexDestination) == false {
            
            return false
        }
        
        //Diagonal movement for either queen or bishop. For example: from index(1,1) to index(3,3) would need to go through (1,1), (2,2), (3,3). Straight movement for either queen or rook, for example from index (1,5) to (1,2) would need to go through (1,5), (1,4), (1,3), (1,2).
        //Get the movement directions in both rows and columns
        var deltaRow = 0
        
        if boardIndexDestination.row - chessPiece.row != 0 {
            
            //This value will be either -1 or 1
            deltaRow = (boardIndexDestination.row - chessPiece.row) / abs(boardIndexDestination.row - chessPiece.row)
        }
        
        var deltaColumn = 0
        
        if boardIndexDestination.column - chessPiece.col != 0 {
            
            deltaColumn = (boardIndexDestination.column - chessPiece.col) / abs(boardIndexDestination.column - chessPiece.col)
        }
        
        //Make sure there are no pieces between itself and the destination cell
        var nextRow = chessPiece.row + deltaRow
        var nextColumn = chessPiece.col + deltaColumn
        
        while nextRow != boardIndexDestination.row || nextColumn != boardIndexDestination.column {
            
            if !(chessBoard[nextRow][nextColumn].type == .dummy) {
                
                return false
            }
            
            nextRow += deltaRow
            nextColumn += deltaColumn
        }
        
        return true
    }
    
    
    func isMoveValid(forKing king: ChessPiece, toBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        if king.isMovementAppropriate(toBoardIndexDestination: boardIndexDestination) == false {
            
            return false
        }
        
        if isAnotherKing(atBoardIndexDestination: boardIndexDestination, forKing: king) {
            
            return false
        }
        
        return true
    }
    
    
    //Called from getPossibleMoves and when move made
    private func isMoveTwoCellsOver(forKing king: ChessPiece, forMove move: BoardIndex) -> Bool {
        
        let deltaColumn = abs(king.col - move.column)
        
        return deltaColumn == 2
    }
    
    
    //Called from getPossibleMoves only
    private func isRookNext(toKing king: ChessPiece, forMove move: BoardIndex) -> Bool {
        
        if king.color == .white {
            
            return move.row == 0 && move.column == 6 && chessBoard[move.row][move.column + 1].type == .rook
        } else if king.color == .black {
            
            return move.row == 7 && move.column == 6 && chessBoard[move.row][move.column + 1].type == .rook
        }
        
        return false
    }
    
    
    func canOpponentAttack(forPlayerKing king: ChessPiece, ifMovedTo boardIndexDestination: BoardIndex) -> Bool {
        
        let opponent: UIColor = king.color == .white ? .black : .white
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                let chessPiece = chessBoard[row][column]
                
                if chessPiece.type == .bishop && chessPiece.color == .black {
                    
                    print("Checking black bishop!!")
                }
                
                if isMoveLegal(forChessPiece: chessPiece, toBoardIndexDestination: boardIndexDestination, considerOwnPiece: false) {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    
    private func isAnotherKing(atBoardIndexDestination boardIndexDestination: BoardIndex, forKing king: ChessPiece) -> Bool {
        
        let opponentColor = king.color == .white ? UIColor.black : .white
        
        //Get other king's boardindex
        var otherKingBoardIndex: BoardIndex!
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                if chessBoard[row][column].type == .king && chessBoard[row][column].color == opponentColor {
                    
                    otherKingBoardIndex = BoardIndex(forRow: row, forColumn: column)
                    
                    break
                }
            }
        }
        
        //Compute absolute difference between the kings
        let rowDifference = abs(otherKingBoardIndex.row - king.row)
        let columnDifference = abs(otherKingBoardIndex.column - king.col)
        
        if (rowDifference == 0 || rowDifference == 1) && (columnDifference == 0 || columnDifference == 1) {
            
            print("Another king is there.")
            return true
        }
        
        return false
    }
    
    
    //Returns true if currentPlayer is under check, false otherwise.
    func isPlayerUnderCheck(forPlayerColor playerColor: UIColor) -> Bool {
        
        guard let playerKing = getKing(forColor: playerColor) else {
            
            print("Something is really wrong!")
            return false
        }
        
        let opponentColor: UIColor = playerColor == .white ? .black : .white
        
        return isKingUnderUnderCheck(forKing: playerKing, byOpponent: opponentColor)
    }
    
    
    private func getKing(forColor color: UIColor) -> ChessPiece? {
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                if chessBoard[row][column].type == .king && chessBoard[row][column].color == color {
                    
                    return chessBoard[row][column]
                }
            }
        }
        
        //Should NEVER get here
        print("Didn't find king. There is a serious problem!")
        
        return nil
    }
    
    
    //Returns true if player's king is under check, false otherwise. Called by another function: isPlayerUnderCheck
    private func isKingUnderUnderCheck(forKing king: ChessPiece, byOpponent color: UIColor) -> Bool {
        
        let kingIndex = BoardIndex(forRow: king.row, forColumn: king.col)
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                if chessBoard[row][column].color == color {
                    
                    if isMoveLegal(forChessPiece: chessBoard[row][column], toBoardIndexDestination: kingIndex, considerOwnPiece: true) {
                        
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    
    //Simulates the move and returns true if making it will expose the player to a check
    func doesMoveExposeKingToCheck(forPlayerPiece piece: ChessPiece, toBoardIndexDestination boardIndexDestination: BoardIndex) -> Bool {
        
        let opponent: UIColor = piece.color == .white ? .black : .white
        
        guard let playerKing = getKing(forColor: piece.color) else {
            
            print("Something wrong in doesMoveExposeKingToCheck logic error")
            
            return false
        }
        
        let kingIndex = BoardIndex(forRow: playerKing.row, forColumn: playerKing.col)
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                let pieceBeingAttacked = chessBoard[boardIndexDestination.row][boardIndexDestination.column]
                
                chessBoard[boardIndexDestination.row][boardIndexDestination.column] = piece
                
                chessBoard[piece.row][piece.col] = ChessPiece(withRow: piece.row, withColumn: piece.col, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
                
                if chessBoard[row][column].color == opponent {
                    
                    if isMoveLegal(forChessPiece: chessBoard[row][column], toBoardIndexDestination: kingIndex, considerOwnPiece: true) {
                        
                        chessBoard[boardIndexDestination.row][boardIndexDestination.column] = pieceBeingAttacked
                        chessBoard[piece.row][piece.col] = piece
                        
                        print("Move will expose king to check")
                        
                        return true
                    }
                }
                
                //Undo fake move
                chessBoard[boardIndexDestination.row][boardIndexDestination.column] = pieceBeingAttacked
                chessBoard[piece.row][piece.col] = piece
            }
        }
        
        return false
    }
    
    
    func printBoard() {
        
        print(String(repeating: "=", count: 40))
        
        for row in 0...7 {
            
            let chessBoardRow = chessBoard[row].map {$0.symbol}
            
            print(chessBoardRow)
        }
        
        print(String(repeating: "=", count: 40))
    }
    
    
    func isWinner(forPlayer color: UIColor, byMove move: BoardIndex) -> Bool {
        
        //Player wins if opponent's king has no more moves and the opponent can't block the check with another one of his pieces
        let attackingPiece = chessBoard[move.row][move.column]
        
        let opponent: UIColor = color == .white ? .black : .white
        
        //Check if the current player's move put opponent in check
        if isPlayerUnderCheck(forPlayerColor: opponent) {
            
            //Does opponent's king have any possible moves
            guard let opponentKing = getKing(forColor: opponent) else {
                
                print("Something seriously wrong in isWinner. Find a solution!")
                
                return false
            }
            
            let possibleKingMoves = getPossibleMoves(forChessPiece: opponentKing)
            
            //Can another piece block the check or take out the piece causing the check
            if possibleKingMoves.count == 0 && !canPlayerEscapeCheck(forPlayer: opponent, fromAttackingPiece: attackingPiece) {
                
                return true
            }
        }
        
        return false
    }
    
    
    func canPlayerEscapeCheck(forPlayer player: UIColor, fromAttackingPiece attackingPiece: ChessPiece) -> Bool {
        
        guard let playerKing = getKing(forColor: player) else {
            
            print("canPlayerEscape really serious error!")
            
            return false
        }
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                let chessPiece = chessBoard[row][column]
                let boardIndexDestination = BoardIndex(forRow: chessPiece.row, forColumn: chessPiece.col)
                
                //If it's one of the player's pieces
                if chessPiece.color == player {
                    
                    let possibleMoves = getPossibleMoves(forChessPiece: chessPiece)
                    
                    //Simulate every possible move and see if it ends check
                    for possibleMove in possibleMoves {
                        
                        if canMove(forMove: possibleMove, takeOutChessPiece: attackingPiece) || canMove(fromIndex: boardIndexDestination, toIndex: possibleMove, blockCheckBy: attackingPiece, forKing: playerKing) {
                            
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    
    func canMove(forMove move: BoardIndex, takeOutChessPiece chessPiece: ChessPiece) -> Bool {
        
        return move.row == chessPiece.row && move.column == chessPiece.col
    }
    
    
    func canMove(fromIndex source: BoardIndex, toIndex destination: BoardIndex, blockCheckBy chessPiece: ChessPiece, forKing king: ChessPiece) -> Bool {
        
        let opponent: UIColor = king.color == .white ? .black : .white
        let movingPiece = chessBoard[source.row][source.column]
        chessBoard[destination.row][destination.column] = movingPiece
        chessBoard[source.row][source.column] = ChessPiece(withRow: 0, withColumn: 0, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
        
        movingPiece.col = destination.column
        movingPiece.row = destination.row
        
        if !isKingUnderUnderCheck(forKing: king, byOpponent: opponent) {
            
            //Undo fake move
            chessBoard[source.row][source.column] = movingPiece
            chessBoard[destination.row][destination.column] = ChessPiece(withRow: destination.row, withColumn: destination.column, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
            
            movingPiece.row = source.row
            movingPiece.col = source.column
            
            return true
        }
        
        //Undo fake move
        chessBoard[source.row][source.column] = movingPiece
        chessBoard[destination.row][destination.column] = ChessPiece(withRow: destination.row, withColumn: destination.column, withColor: .clear, withPieceType: .dummy, forPlayerColor: playerColor)
        
        movingPiece.row = source.row
        movingPiece.col = source.column
        
        return false
    }
    
    
    //Called after the passed in player made a move
    private func isGameTie(withCurrentPlayer player: UIColor) -> Bool {
        
        //If only kings remain game is tied
        if onlyKingsLeft() {
            
            print("Only 2 kings left")
            
            return true
        }
        
        //Or draw if opponent not in check and has no possible moves
        var movesLeft = false
        let opponent: UIColor = player == .white ? .black : .white
        
        let opponentPieces = getAllPieces(forPlayer: opponent)
        
        for opponentPiece in opponentPieces {
            
            if getPossibleMoves(forChessPiece: opponentPiece).count > 0 {
                
                movesLeft = true
            }
        }
        
        return !movesLeft
    }
    
    
    //Helper function called from isGameTie()
    private func getAllPieces(forPlayer player: UIColor) -> [ChessPiece] {
        
        var playerPieces = [ChessPiece]()
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                if chessBoard[row][column].color == player {
                    
                    playerPieces.append(chessBoard[row][column])
                }
            }
        }
        
        return playerPieces
    }
    
    
    //A helper function called from isGameTie()
    private func onlyKingsLeft() -> Bool {
        
        var count = 0
        
        for row in 0...7 {
            
            for column in 0...7 {
                
                if chessBoard[row][column].type != .dummy {
                    
                    count += 1
                }
                
                if count > 2 {
                    
                    return false
                }
            }
        }
        
        return true
    }
    
    
    //Returns true if a pawn is at the end of the board
    private func doesPawnNeedPromotion(forPawn pawn: ChessPiece) -> Bool {
        
        return pawn.type == .pawn && (pawn.row == 0 || pawn.row == 7)
    }
    
    
    //Promote the pawn to the passed in the piece type.
    func promote(forPawn pawn: ChessPiece, intoChessPiece chessPiece: ChessPiece) {
        
        chessBoard[pawn.row][pawn.col] = chessPiece
        
        chessBoardDelegate?.boardUpdated()
    }
}
