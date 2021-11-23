extends LineEdit

var regex: RegEx = RegEx.new()
var old_text: String = ""

onready var main_scene = get_tree().get_root().get_child(0)

func _ready():
	regex.compile("^[1-9]*$")

# Set the text value
func set_value(value: int):
	if value != 0:
		text = str(value)
	else:
		text = ""

# Validation, only accept 1-9
func _on_Value_text_changed(new_text):
	if regex.search(new_text):
		old_text = new_text
	else:
		text = old_text
	set_cursor_position(text.length())
