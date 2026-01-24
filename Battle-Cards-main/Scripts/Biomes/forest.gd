extends Node2D

@onready var stats = biome_stats
@onready var biome = $BaseBiome

var biome_stats: Biome_Resource = null

func _ready():
	tooltip_biome()

func tooltip_biome():
	biome.update_tooltip(str(biome_stats.biome_name), 
	"Flavor Text", 
	"Likes to smash", 
	"")
