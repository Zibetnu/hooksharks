extends Control

onready var boxes = $Boxes.get_children()
onready var bar = $BackIndicator/bar

var available_characters
var starting_game = false
var back_indicator_up_speed = 100
var back_indicator_down_speed = 150
var trying_to_leave_counter = 0

func _ready():
	
	#Reset device map
	RoundManager.device_map = []
	
	available_characters = $Boxes/SelectionBox0.CHARACTERS.duplicate()

	for i in range(boxes.size()):
		boxes[i].connect("selected", self, "_on_box_selected")
		boxes[i].connect("unselected", self, "_on_box_unselected")
		boxes[i].connect("readied", self, "_on_box_readied")
		boxes[i].connect("tried_to_start", self, "_on_box_tried_to_start")
		boxes[i].set_character(0)

func _physics_process(delta):
	if trying_to_leave_counter > 0:
		bar.value = min(100, bar.value + back_indicator_up_speed*delta) 
	else:
		bar.value = max(0, bar.value - back_indicator_down_speed*delta) 
	if bar.value >= 100:
		RoundManager.gamemode = "None"
		get_tree().change_scene("res://main-menu/MainMenu.tscn")	
	elif bar.value > 0:
		bar.visible = true
	else:
		bar.visible = false
	


func _input(event):
	if event.is_action_pressed("ui_start"):
		trying_to_leave_counter = max(0, trying_to_leave_counter - 1)
		for box in boxes:
			if box.is_closed():
				box.open_with(event)
				return
	elif event.is_action_pressed("ui_cancel"):
		trying_to_leave_counter += 1
	elif event.is_action_released("ui_cancel"):
		if not Input.is_action_pressed("ui_cancel"):
			trying_to_leave_counter = max(0, trying_to_leave_counter - 1)
		

func update_boxes():
	for box in boxes:
		box.update_available_characters(available_characters)


func update_device_map():
	for box in boxes:
		if box.is_ready():
			RoundManager.device_map.append(box.device_name)

func can_start():
	var ready_players = 0
	
	for box in boxes:
		if box.is_open():
			return false
		
		if box.is_ready():
			ready_players += 1
	
	if ready_players > 1:
		return true
	
	return false


func start_game():
	if starting_game:
		return
	
	starting_game = true
	
	update_device_map()
	
	if RoundManager.gamemode == "Arena":
		get_tree().change_scene("res://arena-mode/Arena.tscn")
	elif RoundManager.gamemode == "Race":
		get_tree().change_scene("res://race-mode/Race.tscn")


func _on_box_selected(character):
	available_characters.erase(character)
	update_boxes()


func _on_box_unselected(character):
	available_characters.append(character)
	update_boxes()


func _on_box_readied():
	if can_start():
		# Show "press start to begin" message
		pass


func _on_box_tried_to_start():
	if can_start():
		start_game()
