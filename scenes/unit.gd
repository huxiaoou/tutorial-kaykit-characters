@tool
extends CharacterBody3D

class_name Unit

signal rotation_changed(new_rotation: float)

@export var move_speed: float = 5.0
@export var actor_scene: Config.ActorScene = Config.ActorScene.BARBARIAN

var friction: float = 5.0
var jump_velocity: float = 7.0
var gravity: float = 9.8
var actor_instance: AnimationActor = null
var _current_state: State = null
var _states: Dictionary = { }


# --- State Base Class ---
class State:
    var unit: Unit


    func _init(p_unit: Unit) -> void:
        unit = p_unit


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
        unit.apply_floor_gravity(_delta)
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
            unit.apply_movement(direction)
            return ""
        return "idle"


# --- Attack State ---
class AttackState extends State:
    var _finished: bool = true


    func _on_animation_finished(_anim_name: String) -> void:
        _finished = true
        unit.actor_instance.animation_player.animation_finished.disconnect(_on_animation_finished)


    func enter() -> void:
        unit.actor_instance.play_attack()
        unit.actor_instance.animation_player.animation_finished.connect(_on_animation_finished)
        _finished = false


    func physics_update(_delta: float) -> String:
        unit.apply_floor_gravity(_delta)
        if _finished:
            return "idle"
        return ""


# --- Jump State ---
class JumpState extends State:
    func enter() -> void:
        unit.begin_jump()
        unit.actor_instance.play_jump_full_short()


    func physics_update(delta: float) -> String:
        unit.apply_gravity(delta)
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
        "idle": IdleState.new(self),
        "walk": WalkState.new(self),
        "attack": AttackState.new(self),
        "jump": JumpState.new(self),
    }
    _transition_to("idle")
    rotation_changed.connect(_on_rotation_changed)
    return


# --- Unit interface for states ---
# Accumulates gravity each frame and slides. Used by airborne states (jump).
func apply_gravity(delta: float) -> void:
    velocity.y -= gravity * delta
    move_and_slide()


# Resets vertical velocity to a constant downward nudge and slides.
# Used by grounded states (idle) to keep the character pressed to the floor.
func apply_floor_gravity(delta: float) -> void:
    velocity += (-velocity * Config.XZ_PLANE * friction + Vector3.DOWN * gravity) * delta
    move_and_slide()


func apply_movement(direction: Vector2) -> void:
    rotation_changed.emit(-direction.angle())
    velocity = Vector3(direction.x, 0, direction.y) * move_speed + Vector3.DOWN * gravity
    move_and_slide()


func begin_jump() -> void:
    velocity.y = jump_velocity


func _on_rotation_changed(new_rotation: float) -> void:
    var tw: Tween = create_tween()
    var current_rotation: float = actor_instance.rotation.y
    tw.tween_method(
        func(weight: float): actor_instance.rotation.y = lerp_angle(current_rotation, new_rotation, weight),
        0.0,
        1.0,
        0.2,
    )
    return


func _transition_to(state_name: String) -> void:
    if not _states.has(state_name):
        push_error("Unknown state: " + state_name)
        return
    if _current_state:
        _current_state.exit()
    print("Transitioning to state: " + state_name)
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
