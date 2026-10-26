extends Node

var default_settings: Dictionary = {
	"controls": 
	{
		"mouse_sensitivity": 0.5,
	}
}

#region SETTINGS SAVING
func save_settings(settings: Dictionary):
	pass

func load_settings() -> Dictionary:
	return default_settings
#endregion
