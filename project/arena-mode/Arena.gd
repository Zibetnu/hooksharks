extends "res://Game.gd"

func get_cameras():
	return [$Camera2D]

func connect_players():
	for player in players:
		player.connect("created_trail", self, "_on_player_created_trail")
		player.connect("hook_shot", self, "_on_player_hook_shot")
		player.connect("megahook_shot", self, "_on_player_megahook_shot")
		player.connect("died", self, "remove_player")
		player.connect("paused", self, "_on_player_paused")
		for camera in Cameras:
			player.connect("shook_screen", camera, "add_shake")

func activate_players():
	for player in players:
		player.respawn = false
		player.enable()