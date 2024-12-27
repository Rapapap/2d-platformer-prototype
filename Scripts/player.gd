extends CharacterBody2D

#region player variables

# Nodes
@onready var player: AnimatedSprite2D = $AnimatedSprite2D
@onready var playerAnim: AnimationPlayer = $AnimationPlayer

# Physics Variables 
const GRAVITY = 300

# Export Variables
@export_category("Movements")
@export var speed: float
@export var acceleration: float
@export var jumpVelocity: float

# Movements variables
var moveDirection = 0
var direction = 0
var jumpCount = 0

# Input Variables
var keyUp = false
var keyDown = false
var keyLeft = false
var keyRight = false
var keyJump = false
var keyJumpHold = false

func _ready():
	pass
	
func _process(delta: float) -> void:
	# Handle Input
	GetMovementInput()
	
	# Handle Movements
	HorizontalMovement(delta)
	
	move_and_slide()
	
func GetMovementInput():
	keyUp = Input.is_action_pressed("keyUp")
	keyDown = Input.is_action_pressed("keyDown")
	keyLeft = Input.is_action_pressed("keyLeft")
	keyRight = Input.is_action_pressed("keyRight")
	keyJump = Input.is_action_just_pressed("keyJump")
	keyJumpHold = Input.is_action_pressed("keyJump")
	
	if keyRight:
		direction = 1
	elif keyLeft:
		direction = -1
		
func HorizontalMovement(delta: float):
	moveDirection = Input.get_axis("keyLeft", "keyRight")
	velocity.x = move_toward(velocity.x, moveDirection * speed, acceleration * delta)