extends Node2D

var start_scrolling : bool = false

func _ready():
	$CreditsTimer.start()

func _process(delta):
	if $VBoxContainer.position.y <= -800:
		_quit()
	if start_scrolling:
		$VBoxContainer.position.y += 10 * delta

func _on_credits_timer_timeout():
	start_scrolling = true

func _quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
