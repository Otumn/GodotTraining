class_name OptionDropdownResolution
extends OptionDropdown

func _ready() -> void:
	parameter_name = "Resolution"
	super._ready()

func get_res_from_string(text: String) -> Vector2:
	var split = text.split("x", false, 1)
	return Vector2(float(split[0]), float(split[1]))

func _on_option_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(get_res_from_string(options[index]))
	
	@warning_ignore("integer_division")
	var center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	@warning_ignore("integer_division")
	get_window().position = center - window_size/2
	
	super._on_option_button_item_selected(index)
