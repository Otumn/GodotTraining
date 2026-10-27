class_name OptionKeybind
extends Control

@export var config_section = "Section"
@export var input:String = "Keybind"

@onready var param_label: Label = $HBoxContainer/ParamLabel
@onready var button: Button = $HBoxContainer/SettingEdit/Button

var current_event:InputEvent

func _ready() -> void:
	set_process_unhandled_key_input(false)
	param_label.text = clean_input_name(input)
	update_current_event()
	set_key_text()

func clean_input_name(text:String) -> String:
	var new_text:String = ""
	for c in text:
		if c == "_":
			c = " "
		new_text += c
	new_text[0] = new_text[0].capitalize()
	return new_text

func set_key_text():
	var keycode = OS.get_keycode_string(current_event.physical_keycode)
	
	button.text = keycode

func update_current_event():
	var action_events = InputMap.action_get_events(input)
	current_event = action_events[0]

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button.text = "Assign key..."
		set_process_unhandled_key_input(toggled_on)
		
		for b in get_tree().get_nodes_in_group("KeybindButton"):
			b = b as OptionKeybind
			if b.input != input:
				b.button.toggle_mode = false
				set_process_unhandled_key_input(true)
	else:
		set_key_text()
		
		for b in get_tree().get_nodes_in_group("KeybindButton"):
			b = b as OptionKeybind
			if b.input != input:
				b.button.toggle_mode = true
				set_process_unhandled_key_input(false)

func _unhandled_key_input(event: InputEvent) -> void:
	rebind_input(event)
	button.button_pressed = false

func rebind_input(event: InputEvent):
	for b in get_tree().get_nodes_in_group("KeybindButton"):
		b = b as OptionKeybind
		if b.input != input:
			if b.current_event.physical_keycode == event.physical_keycode:
				set_process_unhandled_key_input(false)
				return
	
	InputMap.action_erase_events(input)
	InputMap.action_add_event(input, event)
	
	set_process_unhandled_key_input(false)
	update_current_event()
	set_key_text()


func get_config_value() -> Variant:
	return current_event #will probably not be possible because InputEvent might not be possible to save, as opposed as a String
