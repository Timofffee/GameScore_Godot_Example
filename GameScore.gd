extends Node

var _gs

# коллбек закрытия рекламы
var _cb_rewarded_close = JavaScript.create_callback(self, "_rewarded_close")
signal rewarded_close(success)
signal connected()

func _ready() -> void:
	if OS.has_feature("JavaScript"):
		# Проверяем начличе SDK. Если null, ждём секунду и повторяем
		while _gs == null:
			yield(get_tree().create_timer(1), "timeout")
			_gs = JavaScript.get_interface("gameScore")
		# Подключаем коллбек закрытия рекламы
		_gs.ads.on('rewarded:close', _cb_rewarded_close)
		# Отправляем сигнал, что SDK включено
		emit_signal("connected")

func show_rewarded_video() -> void:
	if _gs == null: return # Проверка налчия SDK
	_gs.ads.showRewardedVideo() # Запуск рекламы

# коллбек закрытия рекламы
func _rewarded_close(args) -> void:
	emit_signal("rewarded_close", bool(args[0]))
