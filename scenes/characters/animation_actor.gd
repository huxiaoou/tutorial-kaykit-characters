extends Node3D

class_name AnimationActor

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rig_medium: Node3D = $Rig_Medium


func _ready() -> void:
    rig_medium.rotate(Vector3.UP, PI / 2)
    print("AnimationActor ready")
    return


func play_idle_a() -> void:
    animation_player.play("Player/Idle_A")


func play_idle_b() -> void:
    animation_player.play("Player/Idle_B")


func play_walking_a() -> void:
    animation_player.play("Player/Walking_A")


func play_walking_b() -> void:
    animation_player.play("Player/Walking_B")


func play_walking_c() -> void:
    animation_player.play("Player/Walking_C")


func play_running_a() -> void:
    animation_player.play("Player/Running_A")


func play_running_b() -> void:
    animation_player.play("Player/Running_B")
