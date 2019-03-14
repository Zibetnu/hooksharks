extends Control

signal selected(character)
signal unselected(character)
signal tried_to_start

enum States {CLOSED, OPEN, READY}

const CHARACTERS = ["a", "b", "c", "d"]

var available_chars = CHARACTERS.duplicate()
var char_index
var device_name = ""
var state = States.CLOSED


func _input(event):
	if RoundManager.get_device_name_from(event) != device_name:
		return
	
	if event.is_action_pressed("ui_start"):
		if state == States.OPEN and CHARACTERS[char_index] in available_chars:
			change_state(States.READY)
		elif state == States.READY:
			emit_signal("tried_to_start")
	
	elif event.is_action_pressed("ui_cancel"):
		if state == States.OPEN:
			device_name = ""
			change_state(States.CLOSED)
		elif state == States.READY:
			change_state(States.OPEN)
	
	elif event.is_action_pressed("ui_left") and state == States.OPEN:
		set_character(char_index - 1)
	
	elif event.is_action_pressed("ui_right") and state == States.OPEN:
		set_character(char_index + 1)
	
	get_tree().set_input_as_handled()


func change_state(new_state):
	match new_state:
		States.CLOSED:
			device_name = ""
			$DeviceSprite.set_texture(null)
			$DeviceNumber.set_text("")
			$State.set_text("CLOSED")
		States.OPEN:
			$State.set_text("OPEN")
			if state == States.READY:
				emit_signal("unselected", CHARACTERS[char_index])
		States.READY:
			$State.set_text("READY")
			emit_signal("selected", CHARACTERS[char_index])
	
	state = new_state


func is_closed():
	return state == States.CLOSED


func is_open():
	return state == States.OPEN


func is_ready():
	return state == States.READY


func open_with(event):
	device_name = RoundManager.get_device_name_from(event)
	if device_name == "keyboard" or (OS.is_debug_build() and device_name == "test_keyboard"):
		$DeviceSprite.set_texture(load("res://hud/character-select/keyboard.png"))
	else:
		$DeviceSprite.set_texture(load("res://hud/character-select/gamepad.png"))
		$DeviceNumber.set_text(str(device_name.split("_")[1]))
	change_state(States.OPEN)


func update_available_characters(characters):
	available_chars = characters
	set_character(char_index)


func set_character(index):
	char_index = wrapi(index, 0, CHARACTERS.size())
	$Character.set_text(str(char_index))
	# Change image here
	
	if not CHARACTERS[char_index] in available_chars:
		# Display as unavailable
		pass
