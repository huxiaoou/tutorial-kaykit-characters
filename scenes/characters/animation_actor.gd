extends Node3D

class_name AnimationActor

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rig_medium: Node3D = $Rig_Medium

const TRANSITION_TIME: float = 0.3


func _ready() -> void:
    rig_medium.rotate(Vector3.UP, PI / 2)
    print("AnimationActor ready")
    return


func play_idle_a() -> void:
    animation_player.play("Player/Idle_A", TRANSITION_TIME)


func play_idle_b() -> void:
    animation_player.play("Player/Idle_B", TRANSITION_TIME)


func play_walking_a() -> void:
    animation_player.play("Player/Walking_A", TRANSITION_TIME)


func play_walking_b() -> void:
    animation_player.play("Player/Walking_B", TRANSITION_TIME)


func play_walking_c() -> void:
    animation_player.play("Player/Walking_C", TRANSITION_TIME)


func play_running_a() -> void:
    animation_player.play("Player/Running_A", TRANSITION_TIME)


func play_running_b() -> void:
    animation_player.play("Player/Running_B", TRANSITION_TIME)


func play_attack() -> void:
    animation_player.play("Player/Throw", TRANSITION_TIME)


func play_jump_full_short() -> void:
    animation_player.play("Player/Jump_Full_Short", TRANSITION_TIME)
