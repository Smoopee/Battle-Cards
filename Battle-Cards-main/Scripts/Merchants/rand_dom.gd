extends Node2D

@onready var stats = merchant_stats
@onready var merchant = $BaseMerchant

var merchant_stats: Merchant_Resource = null

func _ready():
	tooltip_merchant()

func tooltip_merchant():
	merchant.update_tooltip(str(merchant_stats.merchant_name), 
	"Flavor Text", 
	"Sells random cards.", 
	"")
