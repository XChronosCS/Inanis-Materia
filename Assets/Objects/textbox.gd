extends CanvasLayer

@onready var text_label: RichTextLabel = $Panel/DialogueBox/RichTextLabel
@onready var enter_panel: Panel = $Panel/EnterPanel
@onready var enter_panel_text = $"Panel/EnterPanel/Enter Panel Inner/RichTextLabel"
@onready var index = 0
@export var full_text: Array[String] = []
@export var text_trigger_index: int = 0
signal pressedEnter
signal textTriggerReached

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	enter_panel.visible = false
	
func _input(event):
	if event is InputEventKey:
		enter_panel_text.text = "Press Enter to continue"
	elif event is InputEventJoypadButton:
		enter_panel_text.text = "X Button to continue"
	if event.is_action_pressed("advance_dialog"):
		pressedEnter.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		enter_panel.visible = true
		text_label.text = full_text[index]
		await pressedEnter


func _on_pressed_enter():
	if visible:
		if index < full_text.size():
			index += 1
			if index == text_trigger_index:
				textTriggerReached.emit()
				print("Trigger Sent")
			if index == full_text.size():
				index = 0
				DataSave.flags.prevent_player_movement = false
				queue_free()
