extends HBoxContainer

func add_modifier_tooltip(category, identifier, body = null, header = null):
	$Header.text = str(header)
	$Body.text = str(body)
	$Body.name = identifier
