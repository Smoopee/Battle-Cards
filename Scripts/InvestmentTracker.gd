extends Node


var investment_round
var investment_amount = 0

func set_investment():
	investment_round = Global.battle_tracker
	print("InvestmentTracker, amound = " + str(investment_amount))

func cash_in():
	Global.player_gold += ((1 + Global.battle_tracker) - investment_round) * investment_amount
	investment_amount = 0
