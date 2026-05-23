extends Node3D

class_name Mage

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("move"):
        animation_player.play("Player/Running_A")
    elif Input.is_action_just_pressed("jump"):
        animation_player.play("Player/Jump_Full_Short")
