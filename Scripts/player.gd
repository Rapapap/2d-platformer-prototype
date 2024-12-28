# Extends CharacterBody2D to create a player character with movement and input handling
extends CharacterBody2D

#region player variables

# Nodes
@onready var player: AnimatedSprite2D = $AnimatedSprite2D  # Reference to the player's animated sprite
@onready var playerAnim: AnimationPlayer = $AnimationPlayer  # Reference to the player's animation player
# Physics Variables 
const GRAVITY = 300  # Gravity constant for the player
# Export Variables
@export_category("Movements")
@export var speed: float  # Speed of the player

@export_range(0, 1) var acceleration: float = 0.1  # Acceleration rate of the player

@export_range(0, 1) var deceleration: float = 0.1  # Deceleration rate of the player
@export var jumpVelocity: float  # Jump velocity of the player

# Movements variables
var moveDirection = 0  # Direction of movement
var direction     = 0  # Current direction
var jumpCount     = 0  # Count of jumps performed
# Input Variables
var keyUp       = false  # State of the up key
var keyDown     = false  # State of the down key
var keyLeft     = false  # State of the left key
var keyRight    = false  # State of the right key
var keyJump     = false  # State of the jump key
var keyJumpHold = false  # State of the jump hold key


func _ready():
	pass  # Called when the node is ready


func _process(delta: float) -> void:
	# Handle Input
	GetMovementInput()

	# Handle Movements
	HorizontalMovement(delta)
	
	move_and_slide()  # Move the player and handle collisions
	

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
	if moveDirection:
		velocity.x = move_toward(velocity.x, moveDirection * speed, acceleration * speed)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * speed)
	moveDirection = Input.get_axis("keyLeft", "keyRight")
