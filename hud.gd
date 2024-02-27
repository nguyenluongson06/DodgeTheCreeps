extends CanvasLayer
signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#show the given message
func show_message(text):
	#set text content of Message node to the given message
	$Message.text = text
	#and show the node
	get_node("Message").show()
	#start the message timer
	get_node("MessageTimer").start()
	pass


func show_game_over():
	show_message("Game over")
	#wait for message timer to time out
	await $MessageTimer.timeout
	#then set its text to the original then show it
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
