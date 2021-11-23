class_name SudokuGenerator

# Generate array of sudoku problem with 0 values, example result --> [[0, 0, 0, 0, 0, 0, 0, 0, 0], ...]
func generate_empty_board() -> Array:
	var final_value: Array = []
	var grid_size: int = 9
	
	for row in range(0, grid_size):
		final_value.insert(row, [])
		for col in range(0, grid_size): 
			final_value[row].insert(col, 0)
	
	return final_value

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

# Generate random sudoku solution board
func sudoku(puzzle: Array) -> bool:
	var row = find_next_empty(puzzle)[0]
	var col = find_next_empty(puzzle)[1]
	
	if row == null:
		return true

	var i: int = 0
	var random_choices: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	
	while i < 9:
		randomize()
		var guess: int = random_choices[randi() % random_choices.size()]
		random_choices.remove(random_choices.find(guess, 0))

		if is_valid(puzzle, guess, row, col):
			puzzle[row][col] = guess
			if sudoku(puzzle):
				return true

		puzzle[row][col] = 0
		i+=1

	return false

# The actual sudoku problem, get rid some value in the solution to make a puzzle
func sudoku_problem(puzzle: Array, puzzle_difficulty: String) -> Array:
	var final_value: Array = puzzle
	var limit

	for row in range(0, 9):
		# How many row values to be change
		if puzzle_difficulty == "Easy":
			limit = rand_range(1, 3)
		elif puzzle_difficulty == "Medium":
			limit = rand_range(3, 5)
		elif puzzle_difficulty == "Hard":
			limit = rand_range(5, 7)
			
		var random_choices: Array = [0, 1, 2, 3, 4, 5, 6, 7, 8]

		var i: int = 0
		
		while i < limit:
			randomize()
			var random_col: int = random_choices[randi() % random_choices.size()]
			random_choices.remove(random_choices.find(random_col, 0))

			final_value[row][random_col] = 0 # Row values become 0
			i+=1
	
	return final_value
