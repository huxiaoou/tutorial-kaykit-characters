@tool
extends CharacterBody3D

class_name Unit

@export var move_speed: float = 5.0
@export var actor_scene: Config.ActorScene = Config.ActorScene.BARBARIAN

var actor_instance: AnimationActor = null


func _ready():
    load_actor()
    return


func load_actor():
    var scene_path = Config.ACTOR_SCENE_PATHS[actor_scene]
    var actor_scene_resource = load(scene_path)
    actor_instance = actor_scene_resource.instantiate()
    add_child(actor_instance)
    return


func _physics_process(_delta: float) -> void:
    if Engine.is_editor_hint():
        return
    var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    if direction != Vector2.ZERO:
        actor_instance.play_running_a()
        actor_instance.global_rotation.y = -direction.angle()
        velocity = Vector3(direction.x, 0, direction.y) * move_speed
        move_and_slide()
    else:
        actor_instance.play_idle_a()
    return
