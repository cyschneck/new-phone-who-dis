extends Node

var is_showing_transition = false 
var transition_node_name = "transitionSprite"

var function_to_call: Callable # function with parameters

enum TransitionType {SwipeUp=1, SwipeRight=2, SwipeLeft=3}

func setup_screenshot_sprite() -> Sprite2D:
	var transition_sprite = load("res://scenes/manager/transition_sprite.tscn").instantiate()
	# take screenshot of screen
	var screenshot_image = get_viewport().get_texture().get_image()
	# set up image as a texture
	var transition_texture = ImageTexture.create_from_image(screenshot_image)
	transition_sprite.name = transition_node_name
	# set texture
	transition_sprite.texture = transition_texture
	return transition_sprite

func show_transition(_new_node: Node, transition_sprite: Sprite2D, transition_type: TransitionType) -> void:
	# check if a transition node already exists
	if get_tree().root.get_node_or_null(transition_node_name) != null:
		return
	# add a transition sprite
	get_tree().root.add_child(transition_sprite)

	# add tween
	var transition_tween = create_tween().set_parallel() # mulitple transitions at once
	
	# change the transition based on transition type
	if transition_type == TransitionType.SwipeUp:
		transition_tween.set_trans(Tween.TRANS_CUBIC)
		transition_tween.tween_property(transition_sprite, "position", Vector2(0,-1200), 2)
	if transition_type == TransitionType.SwipeRight:
		transition_tween.set_trans(Tween.TRANS_QUINT)
		transition_tween.tween_property(transition_sprite, "position", Vector2(-1440,0), 1)
	if transition_type == TransitionType.SwipeLeft:
		transition_tween.set_trans(Tween.TRANS_QUINT)
		transition_tween.tween_property(transition_sprite, "position", Vector2(1400,0), 1)

	# remove node after transition
	transition_tween.finished.connect(transition_sprite.queue_free)
	await transition_tween.finished
	get_tree().node_added.disconnect(function_to_call)
	# once animation is finished and node is removed
	is_showing_transition = false

func change_scene(new_scene_location: String, transition_type: int) -> void:
	# prevent overlapping transitions
	if is_showing_transition:
		return
	# start transition
	is_showing_transition = true
	var transition_sprite = setup_screenshot_sprite()
	# transition between scenes
	get_tree().change_scene_to_file(new_scene_location)
	# show transition during scene
	function_to_call = show_transition.bind(transition_sprite, transition_type)
	# connect function
	get_tree().node_added.connect(function_to_call)
	
