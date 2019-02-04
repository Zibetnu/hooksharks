extends Control

func _ready():
	$StartRace.grab_focus()


func _on_StartRace_pressed():
	BGM.get_node('Click').play()
	get_tree().change_scene("res://race-mode/Race.tscn")


func _on_StartArena_pressed():
	BGM.get_node('Click').play()
	get_tree().change_scene("res://Main.tscn")


func _on_Quit_pressed():
	get_tree().quit()