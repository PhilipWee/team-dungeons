extends Node2D

#onready var player = preload("res://Player/Adventurer.tscn")
onready var player = preload("res://Player/Rogue.tscn")
onready var slime = preload("res://Enemy/Slime.tscn")
onready var HUD = preload("res://HUD/HUD.tscn")

onready var MapMaker = $MapMaker

func _ready():
	pass

