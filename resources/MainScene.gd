extends Node

var sudoku_generator: SudokuGenerator = SudokuGenerator.new()
var board: Array = sudoku_generator.generate_empty_board()

var sudoku_solver: SudokuSolver = SudokuSolver.new()

onready var sudoku: Node = get_node("Sudoku")

var problem: Array

onready var difficulty: OptionButton = get_node("UI/NewPuzzle/Difficulty")
onready var difficulty_btn: Button = get_node("UI/NewPuzzle/Generate")
var puzzle_difficulty: String

var player_answer: Array

onready var solving_speed: OptionButton = get_node("UI/Solve/SolvingSpeed")
onready var solving_speed_btn: Button = get_node("UI/Solve/Solve")
var puzzle_solving_speed: String

onready var message: Label = get_node("UI/Message/Label")

var stop = false

func _ready() -> void:
	add_item()
	
	puzzle_difficulty = difficulty.get_item_text(difficulty.get_selected_id())
	sudoku_generator.sudoku(board)
	sudoku_generator.sudoku_problem(board, puzzle_difficulty)
	display_puzzle(board)
	
	problem = problem_puzzle()
	puzzle_solving_speed = solving_speed.get_item_text(solving_speed.get_selected_id())
	
# Adding choices in option buttons in Difficulty and Solving Speed
func add_item() -> void:
	difficulty.add_item("Easy")
	difficulty.add_item("Medium")
	difficulty.add_item("Hard")
	
	solving_speed.add_item("Instant")
	solving_speed.add_item("0.1s")
	solving_speed.add_item("1s")

# Set problem through getting the text of every Value
func problem_puzzle() -> Array:
	var final_value: Array = []
	
	for row in range(0, sudoku.get_child_count()):
		final_value.insert(row, [])
		for col in range(0, 9):
			if sudoku.get_child(row).get_child(col).text != "":
				final_value[row].insert(col, int(sudoku.get_child(row).get_child(col).text))
			else:
				final_value[row].insert(col, 0)
	
	return final_value

# Get the player answer through getting the text of every Value
func get_player_answer() -> Array:
	var final_value: Array = []
	
	for row in range(0, sudoku.get_child_count()):
		final_value.insert(row, [])
		for col in range(0, 9):
			if sudoku.get_child(row).get_child(col).text != "":
				final_value[row].insert(col, int(sudoku.get_child(row).get_child(col).text))
			else:
				final_value[row].insert(col, 0)
	
	return final_value

# Option button for difficulty
func _on_Difficulty_item_selected(index: int) -> void:
	puzzle_difficulty = difficulty.get_item_text(index)
	new_puzzle()

# Generate button
func _on_Generate_pressed() -> void:
	new_puzzle()
	
# Generate new puzzle
func new_puzzle() -> void:
	stop = true
	
	solving_speed.disabled = false
	solving_speed_btn.disabled = false
	
	solving_speed.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	solving_speed_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	# Solve the puzzle
	board = sudoku_generator.generate_empty_board()
	sudoku_generator.sudoku(board)
	sudoku_generator.sudoku_problem(board, puzzle_difficulty)
	display_puzzle(board)
	
	problem = problem_puzzle()
	
	message.text = ""
	message.modulate = Color.white

# Display the problem in the board
func display_puzzle(puzzle: Array) -> void:
	for row in range(0, len(puzzle)):
		for col in range(0, len(puzzle)):
			if puzzle[row][col] != 0:
				sudoku.get_child(row).get_child(col).set_value(puzzle[row][col])
				sudoku.get_child(row).get_child(col).editable = false
			else:
				sudoku.get_child(row).get_child(col).set_value(puzzle[row][col])
				sudoku.get_child(row).get_child(col).editable = true

# Submit Player answer		
func _on_Submit_pressed() -> void:
	player_answer = get_player_answer() # Get the Player answer in the board
	
	sudoku_solver.sudoku_instant(board) # Solve the board
	
	# Check if the answer is correct then show message
	if board == player_answer:
		message.text = "Correct :)"
		message.modulate = "#6bff85" 
	else:
		message.text = "Wrong Answer :("
		message.modulate = "#ffb6b6"
	
	board = problem # Set the board again, board to problem

# Option button of Solving speed
func _on_SolvingSpeed_item_selected(index: int):
	puzzle_solving_speed = solving_speed.get_item_text(index)

# Solve button
func _on_Solve_pressed() -> void:
	stop = false
	
	solving_speed.disabled = true
	solving_speed_btn.disabled = true
	
	solving_speed.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	solving_speed_btn.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	
	solve_puzzle()
	
# Solve the problem		
func solve_puzzle() -> void:
	if puzzle_solving_speed == "Instant":
		sudoku_solver.sudoku_instant(board)
		display_solution(board)
		
	elif puzzle_solving_speed == "0.1s":
		sudoku_solver.solving_process = []
		sudoku_solver.sudoku(board)
		solving_process(sudoku_solver.solving_process, 0.05)
		
	elif puzzle_solving_speed == "1s":
		sudoku_solver.solving_process = []
		sudoku_solver.sudoku(board)
		solving_process(sudoku_solver.solving_process, 0.5)
		
# Display the puzzle answer instantly
func display_solution(puzzle: Array) -> void:
	for row in range(0, len(puzzle)):
		for col in range(0, len(puzzle)):
			if puzzle[row][col] != 0:
				sudoku.get_child(row).get_child(col).set_value(puzzle[row][col])
			else:
				sudoku.get_child(row).get_child(col).set_value(puzzle[row][col])

# Solve the puzzle with visualization
func solving_process(puzzle: Array, timer: float) -> void:
	for i in range(0, len(puzzle)):
		if puzzle[i][2] != 0:
			sudoku.get_child(puzzle[i][0]).get_child(puzzle[i][1]).modulate = "#6bff85" 
			sudoku.get_child(puzzle[i][0]).get_child(puzzle[i][1]).set_value(puzzle[i][2])
			yield(get_tree().create_timer(timer), "timeout")
			sudoku.get_child(puzzle[i][0]).get_child(puzzle[i][1]).modulate = Color.white
			
		elif puzzle[i][2] == 0 and sudoku.get_child(puzzle[i][0]).get_child(puzzle[i][1]).text != "":
			sudoku.get_child(puzzle[i][0]).get_child(puzzle[i][1]).modulate =  "#ffb6b6"
			sudoku.get_child(puzzle[i][0]).get_child(puzzle[i][1]).set_value(puzzle[i][2])
			yield(get_tree().create_timer(timer), "timeout")
			sudoku.get_child(puzzle[i][0]).get_child(puzzle[i][1]).modulate = Color.white
		
		if stop:
			break
