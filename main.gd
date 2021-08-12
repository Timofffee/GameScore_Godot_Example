extends Control

var gold = 0 # типо наше золото

func _ready() -> void:
	# Подписываемся на сигнал включения SDK (один раз)
	GameScore.connect("connected", self, "_sdk_connected", [], CONNECT_ONESHOT)

func _sdk_connected() -> void:
	$Label.text = "GameScore Activated"
	# Подключаем показ рекламы при нажатии на кнопку
	$Button.connect("pressed", GameScore, "show_rewarded_video")
	# Подключаем коллбек, чтобы отслеживать закрытие рекламы
	GameScore.connect("rewarded_close", self, "_rewarded_closed")

# Обрабатываем закрытие рекламы
func _rewarded_closed(success) -> void:
	if success: # видео просмотренно до конца?
		gold += 100 # если да - плюс золото
		$Gold.text = "Gold: " + str(gold)
