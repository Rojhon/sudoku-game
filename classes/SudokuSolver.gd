class_name SudokuSolver

var solving_process: Array = []

# Find the next row and col with value of 0
func find_next_empty(puzzle: Array) -> Array:
	for r in range(9):
		for c in range(9):
			if puzzle[r][c] == 0:
				return [r, c]

	return [null, null]
	
# Check if the guess is valid
func is_valid(puzzle: Array, guess: int, row: int, col: int) -> bool:
	# Check if the guess is valid in row
	var row_vals: Array = puzzle[row]
	if guess in row_vals:
		return false

	# Check if the guess is valid in col
	var col_vals: Array = []
	for i in range(9):
		col_vals.append(puzzle[i][col])

	if guess in col_vals:
		return false

	# Check if the guess is valid in square
	var row_start: int = (row / 3) * 3 
	var col_start: int = (col / 3) * 3

	for r in range(row_start, row_start + 3):
		for c in range(col_start, col_start + 3):
			if puzzle[r][c] == guess:
				return false

	return true
	
# Solve the board instantly
func sudoku_instant(puzzle: Array) -> bool:
	var row = find_next_empty(puzzle)[0]
	var col = find_next_empty(puzzle)[1]
	
	if row == null:
		return true

	for guess in range(1, 10):
		if is_valid(puzzle, guess, row, col):
			puzzle[row][col] = guess
			
			if sudoku_instant(puzzle):
				return true

		puzzle[row][col] = 0
		
	return false
	
# Solve the board with appending the process of solving
func sudoku(puzzle: Array) -> bool:
	var row = find_next_empty(puzzle)[0]
	var col = find_next_empty(puzzle)[1]
	
	if row == null:
		return true

	for guess in range(1, 10):
		if is_valid(puzzle, guess, row, col):
			puzzle[row][col] = guess
			
			solving_process.append([row, col, guess])
			
			if sudoku(puzzle):
				return true

		puzzle[row][col] = 0
		
	solving_process.append([row, col, 0])
	return false
