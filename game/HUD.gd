extends Control

signal start_game

func _on_StartButton_pressed():
	emit_signal("start_game")
	$StartButton.hide()