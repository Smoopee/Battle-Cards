extends CanvasLayer

var next_scene: String = "res://Scenes/UI/StartScreen/start_screen.tscn"

func _ready():
	ResourceLoader.load_threaded_request(next_scene, "")

func _process(delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(next_scene)
	
	if load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		var pack_next_scene = ResourceLoader.load_threaded_get(next_scene)
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(pack_next_scene)
