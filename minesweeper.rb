#!/usr/bin/ruby

class Minesweeper
  @board = []
  @lastGuess = [-1, -1]

  def board(set=false, x=3, y=3, mines=0.5)
    #return the board (basically a global variable)
    #if set is true, generate a random board of x and y dimensions.
    board = @board
    if set
      @board = []
      x.times do
        row = []
        y.times do
          if Random.rand < mines
            row << ['x', false]
          else
            row << ['o', false]
          end
        end
        @board << row
      end
    end
    return board
  end

  def printBoard(b)
    #print out a board
    b.length.times do
      |x|
      b[x].length.times do
        |y|
        if b[x][y][1]
          if x == @lastGuess[0] and y == @lastGuess[1]
            print("\e[44m")
            print("\e[30m")
            print(b[x][y][0])
            print("\e[0m")
          else
            print(b[x][y][0])
          end
          print(" ")
        else
          print('# ')
        end
      end
      puts
    end
  end

  def showExtraSquares(b, x, y)
    #show any connected number squares
    b[x][y][1] = true
    x1 = x-1
    y1 = y-1
    x2 = x+1
    y2 = y+1
    if x1 >= 0 and b[x1][y][0] != 'x' and b[x1][y][1] == false
      showExtraSquares(board(), x1, y)
    end
    if x2 < b.length and b[x2][y][0] != 'x' and b[x2][y][1] == false
      showExtraSquares(board(), x2, y)
    end
    if y1 >= 0 and b[x][y1][0] != 'x' and b[x][y1][1] == false
      showExtraSquares(board(), x, y1)
    end
    if y2 < b[x].length and b[x][y2][0] != 'x' and b[x][y2][1] == false
      showExtraSquares(board(), x, y2)
    end
    return
  end

  def calcNum(b, x, y)
    #get the num of mines around
    num = 0
    3.times do
      |x1|
      3.times do
        |y1|
        x3 = x1-1
        y3 = y1-1
        x2 = x + x3
        y2 = y + y3
        if x2 >= 0 and x2 < b.length
          if y2 >= 0 and y2 < b[x2].length
            if b[x2][y2][0] == 'x'
              num = num + 1
            end
          end
        end
      end
    end

    return num
  end

  def won()
    #return true if only xs are still hidden
    board().each do
      |row|
      row.each do
        |item|
        if item[0] != 'x' and item[1] == false
          return false
        end
      end
    end
    return true
  end

  def uncover_all(b)
    b.each do
      |row|
      row.each do
        |elem|
        elem[1] = true
      end
    end
    return b
  end

  def guess(b, x, y)
    #return true if guess is good, false if mine
    @lastGuess = [x, y]
    if b[x][y][0] == 'x'
      b[x][y][1] = true
      return false
    else
      b[x][y][0] = calcNum(b, x, y)
      showExtraSquares(b, x, y)
      b[x][y][1] = true
      return true
    end
  end

  def guess_loop()
    #after game is initialized, loop asking for a guess each time. lose when guess is mine.
    safe = true
    win = false
    printBoard(board())

    while safe
      puts "Please give an x and a y separated by a space:"
      vals = gets().chomp.split
      y = vals[0].to_i
      x = vals[1].to_i
      if x >= 0 and x < board().length and y >= 0 and y < board()[0].length
        safe = guess(board(), x, y)

        puts
        printBoard(board())
        puts
        if safe
          if won()
            win = true
            break
          end
        end
      end
    end
    if !win
      puts "You Lose!"
    else
      puts "You Win!"
    end


    uncover_all(board())
    printBoard(board())
  end

  def main_loop()
    while true
      puts
      puts "---------------NEW GAME---------------"
      puts
      #initialize game and offer to play again
      puts "Please enter x dimension:"
      x = gets.chomp.to_i
      puts "Please enter y dimension:"
      y = gets.chomp.to_i
      mine = 2.0
      while mine > 1
        puts "Please enter mine proportion as a float:"
        mine = gets.chomp.to_f
      end

      board(true, y, x, mine)
      board().length.times do
        |row|
        board()[row].length.times do
          |item|
          if board()[row][item][0] == 'o'
            board()[row][item][0] = calcNum(board(), row, item)
          end
        end
      end	
      guess_loop()
    end
  end
end

Minesweeper.new().main_loop()
