# Extends CharacterBody2D to create a player character with movement and input handling
extends CharacterBody2D

#region player variables

# Nodes
@onready var player: AnimatedSprite2D = $AnimatedSprite2D  # Reference to the player's animated sprite
@onready var playerAnim: AnimationPlayer = $AnimationPlayer  # Reference to the player's animation player
@onready var camera: Camera2D = $Camera2D  # Reference to the camera
@onready var States: Node = $StateMachine  # Reference to the state machine

# Physics Variables 
const GRAVITY: int = 300  # Gravity constant for the player

# Export Variables
@export_category("Movements")
@export var speed: float  # Speed of the player
@export_range(0, 100) var acceleration: float = 30  # Acceleration rate of the player
@export_range(0, 100) var deceleration: float = 15  # Deceleration rate of the player
@export var jumpVelocity: float  # Jump velocity of the player

# Movements variables
var moveDirection: int = 0  # Direction of movement
var direction: int     = 0  # Current direction
var jumpCount: int     = 0  # Count of jumps performed
var maxJumps: int      = 1  # Maximum number of jumps allowed

# Input Variables
var keyUp: bool       = false  # State of the up key
var keyDown: bool     = false  # State of the down key
var keyLeft: bool     = false  # State of the left key
var keyRight: bool    = false  # State of the right key
var keyJump: bool     = false  # State of the jump key
var keyJumpHold: bool = false  # State of the jump hold key

# State Machine
var currentState = null
var previousState = null

func _ready():
	# Initialize State Machine
	for state in States.get_children():
		state.States = States
		state.Player = self
		
	previousState = States.fall
	currentState = States.idle
	
func _process(delta: float) -> void:
	print(jumpCount)
	# Handle Input
	GetMovementInput()

	# Handle Movements
	HorizontalMovement()
	HandleJump()
	HandleGravity(delta)

	move_and_slide()  # Move the player and handle collisions

	# Handle Animations
	AnimationsHandler()
	
func ChangeState(newState):
	if newState != null:
		previousState = currentState
		currentState = newState
		previousState.ExitState()
		currentState.EnterState()
		print("State Change to: ", newState.Name, " from: ", previousState.Name)

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


func HorizontalMovement():
	moveDirection = Input.get_axis("keyLeft", "keyRight")

	if moveDirection:
		velocity.x = move_toward(velocity.x, moveDirection * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
	moveDirection = Input.get_axis("keyLeft", "keyRight")


func HandleJump():
	if (keyJump):
		if (jumpCount < maxJumps):
			velocity.y -= jumpVelocity
			jumpCount += 1
			print(jumpCount)


func AnimationsHandler():
	# handle sprite flip
	player.flip_h = direction < 0

	# Another way to handle sprite flip	
	#	if direction == 1:
	#		player.flip_h = false
	#	elif direction == -1:
	#		player.flip_h = true

	if is_on_floor():
		if velocity.x != 0:
			playerAnim.play("Player/Run")
		else:
			playerAnim.play("Player/Idle")
	else:
		if velocity.y < 0:
			playerAnim.play("Player/Jump")
		else:
			playerAnim.play("Player/Fall")

func HandleGravity(delta):
	# Handle Gravity
	if not is_on_floor() and jumpCount < maxJumps:
		velocity.y += GRAVITY * delta
	else:
		jumpCount = 0			