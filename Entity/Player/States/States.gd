extends Node

# States Variables
@onready var idle: Node = $Idle
@onready var run: Node = $Run
@onready var jump: Node = $Jump
@onready var jumpPeak: Node = $JumpPeak
@onready var fall: Node = $Fall