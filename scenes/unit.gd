@tool
extends CharacterBody3D

class_name Unit

@export var move_speed: float = 5.0
@export var jump_velocity: float = 5.0
@export var gravity: float = 9.8
@export var actor_scene: Config.ActorScene = Config.ActorScene.BARBARIAN

var actor_instance: AnimationActor = null
var _current_state: State = null
var _states: Dictionary = {}


# --- State Base Class ---
class State:
    var unit: Unit

    func enter() -> void:
        pass

    func exit() -> void:
        pass

    func physics_update(_delta: float) -> String:
        return ""


# --- Idle State ---
class IdleState extends State:
    func enter() -> void:
        unit.actor_instance.play_idle_a()

    func physics_update(_delta: float) -> String:
        var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
        if direction != Vector2.ZERO:
            return "walk"
        if Input.is_action_just_pressed("attack"):
            return "attack"
        if Input.is_action_just_pressed("jump") and unit.is_on_floor():
            return "jump"
        return ""


# --- Walk State ---
class WalkState extends State:
    func enter() -> void:
        unit.actor_instance.play_walking_a()

    func physics_update(_delta: float) -> String:
        var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
        if Input.is_action_just_pressed("attack"):
            return "attack"
        if Input.is_action_just_pressed("jump") and unit.is_on_floor():
            return "jump"
        if direction != Vector2.ZERO:
            unit.actor_instance.global_rotation.y = -direction.angle()
            unit.velocity = Vector3(direction.x, 0, direction.y) * unit.move_speed
            unit.move_and_slide()
            return ""
        return "idle"


# --- Attack State ---
class AttackState extends State:
    var _started: bool = false

    func enter() -> void:
        _started = false
        unit.actor_instance.play_throw()

    func physics_update(_delta: float) -> String:
        if not _started:
            _started = true
            return ""
        if unit.actor_instance.is_animation_finished():
            return "idle"
        return ""


# --- Jump State ---
class JumpState extends State:
    func enter() -> void:
        unit.velocity.y = unit.jump_velocity
        unit.actor_instance.play_jump_full_short()

    func physics_update(delta: float) -> String:
        unit.velocity.y -= unit.gravity * delta
        unit.move_and_slide()
        if unit.is_on_floor():
            unit.velocity.y = 0.0
            var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
            if direction != Vector2.ZERO:
                return "walk"
            return "idle"
        return ""


func _ready() -> void:
    load_actor()
    if Engine.is_editor_hint():
        return
    _states = {
        "idle": IdleState.new(),
        "walk": WalkState.new(),
        "attack": AttackState.new(),
        "jump": JumpState.new(),
    }
    for state in _states.values():
        state.unit = self
    _transition_to("idle")
    return


func _transition_to(state_name: String) -> void:
    if not _states.has(state_name):
        push_error("Unknown state: " + state_name)
        return
    if _current_state:
        _current_state.exit()
    _current_state = _states[state_name]
    _current_state.enter()


func load_actor() -> void:
    var scene_path = Config.ACTOR_SCENE_PATHS[actor_scene]
    var actor_scene_resource = load(scene_path)
    actor_instance = actor_scene_resource.instantiate()
    add_child(actor_instance)
    return


func _physics_process(delta: float) -> void:
    if Engine.is_editor_hint():
        return
    var next_state: String = _current_state.physics_update(delta)
    if next_state != "":
        _transition_to(next_state)
    return
