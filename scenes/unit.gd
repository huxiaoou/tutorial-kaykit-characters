@tool
extends CharacterBody3D

class_name Unit

signal rotation_changed(new_rotation: float)

@export var move_speed: float = 5.0
@export var actor_scene: Config.ActorScene = Config.ActorScene.BARBARIAN
@export var data_equipment: DataEquipment = preload("res://resources/axe_1handed.tres")

var friction: float = 4.0
var jump_velocity: float = 7.0
var gravity: float = -9.8
var actor_instance: AnimationActor = null
var unit_fsm: UnitFsm = null


func _ready() -> void:
    load_actor()
    if Engine.is_editor_hint():
        return
    rotation_changed.connect(_on_rotation_changed)
    unit_fsm = UnitFsm.new()
    unit_fsm.setup(self)
    if data_equipment:
        actor_instance.equip_weapon(data_equipment)
    return


# --- Unit interface for states ---
func apply_gravity(delta: float) -> void:
    velocity.y += gravity * delta
    move_and_slide()


func apply_floor_gravity(delta: float) -> void:
    velocity += (-velocity * Config.XZ_PLANE * friction + Vector3.UP * gravity) * delta
    move_and_slide()


func apply_movement(direction: Vector2, delta: float) -> void:
    rotation_changed.emit(-direction.angle())
    velocity = Vector3(direction.x, 0, direction.y) * move_speed + Vector3.UP * gravity * delta
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


func load_actor() -> void:
    var scene_path = Config.ACTOR_SCENE_PATHS[actor_scene]
    var actor_scene_resource = load(scene_path)
    actor_instance = actor_scene_resource.instantiate()
    add_child(actor_instance)
    return
