extends Node

class_name UnitFsm

enum StateId {
    IDLE,
    WALK,
    ATTACK,
    JUMP,
}


# --- State Base Class ---
class State:
    var id: StateId
    var unit: Unit


    func _init(p_unit: Unit) -> void:
        unit = p_unit


    func enter() -> void:
        pass


    func exit() -> void:
        pass


    func physics_update(_delta: float) -> StateId:
        return StateId.IDLE


# --- Idle State ---
class IdleState extends State:
    func _init(p_unit: Unit) -> void:
        super._init(p_unit)
        id = StateId.IDLE


    func enter() -> void:
        unit.actor_instance.play_idle_a()


    func physics_update(delta: float) -> StateId:
        var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
        unit.apply_floor_gravity(delta)
        if direction != Vector2.ZERO:
            return StateId.WALK
        if Input.is_action_just_pressed("attack"):
            return StateId.ATTACK
        if Input.is_action_just_pressed("jump") and unit.is_on_floor():
            return StateId.JUMP
        return StateId.IDLE


# --- Walk State ---
class WalkState extends State:
    func _init(p_unit: Unit) -> void:
        super._init(p_unit)
        id = StateId.WALK


    func enter() -> void:
        unit.actor_instance.play_walking_a()


    func physics_update(delta: float) -> StateId:
        var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
        if Input.is_action_just_pressed("attack"):
            return StateId.ATTACK
        if Input.is_action_just_pressed("jump") and unit.is_on_floor():
            return StateId.JUMP
        if direction != Vector2.ZERO:
            unit.apply_movement(direction, delta)
            return StateId.WALK
        return StateId.IDLE


# --- Attack State ---
class AttackState extends State:
    var _finished: bool = true


    func _init(p_unit: Unit) -> void:
        super._init(p_unit)
        id = StateId.ATTACK


    func _on_animation_finished(_anim_name: String) -> void:
        _finished = true
        unit.actor_instance.animation_player.animation_finished.disconnect(_on_animation_finished)


    func enter() -> void:
        unit.actor_instance.play_attack()
        unit.actor_instance.animation_player.animation_finished.connect(_on_animation_finished)
        _finished = false


    func physics_update(_delta: float) -> StateId:
        unit.apply_floor_gravity(_delta)
        if _finished:
            return StateId.IDLE
        return StateId.ATTACK


# --- Jump State ---
class JumpState extends State:
    func _init(p_unit: Unit) -> void:
        super._init(p_unit)
        id = StateId.JUMP


    func enter() -> void:
        unit.begin_jump()
        unit.actor_instance.play_jump_full_short()


    func physics_update(_delta: float) -> StateId:
        unit.apply_gravity(_delta)
        if unit.is_on_floor():
            unit.velocity.y = 0.0
            var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
            if direction != Vector2.ZERO:
                return StateId.WALK
            return StateId.IDLE
        return StateId.JUMP


var _current_state: State = null
var _states: Dictionary[StateId, State] = { }


func setup(unit: Unit) -> void:
    unit.add_child(self)
    _states = {
        StateId.IDLE: UnitFsm.IdleState.new(unit),
        StateId.WALK: UnitFsm.WalkState.new(unit),
        StateId.ATTACK: UnitFsm.AttackState.new(unit),
        StateId.JUMP: UnitFsm.JumpState.new(unit),
    }
    _transition_to(_states[StateId.IDLE])
    return


func _transition_to(next_state: State) -> void:
    if _current_state:
        _current_state.exit()
    _current_state = next_state
    print("Transitioning to state: " + str(_current_state.id))
    _current_state.enter()


func _physics_process(delta: float) -> void:
    var next_state_id: StateId = _current_state.physics_update(delta)
    var next_state: State = _states.get(next_state_id, null)
    if next_state != _current_state:
        _transition_to(next_state)
    return
