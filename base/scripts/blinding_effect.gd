class_name BlindingEffect
extends CanvasLayer

@onready var base_color_rect = $BaseColorRect
@onready var noise_color_rect = $NoiseColorRect  # Новый узел для шума

var current_tween: Tween = null
signal blind_finished
signal unblind_finished


func _ready():
	base_color_rect.color = Color(1, 1, 1, 0)  # Изначально полностью прозрачный белый фон

	# Инициализируем параметр шума в шейдере на 0.0 (без шума)
	if noise_color_rect.material is ShaderMaterial:
		(noise_color_rect.material as ShaderMaterial).set_shader_parameter("noise_amount", 0.0)

	hide()  # Скрываем эффект по умолчанию


# Функция для запуска эффекта ослепления
# Добавлен параметр noise_peak_amount для контроля максимальной интенсивности шума
func start_blinding(
	duration: float = 0.75,
	fade_to_color: Color = Color(1.0, 1.0, 1.0, 0.96),
	noise_peak_amount: float = 0.4
):
	if current_tween != null and current_tween.is_running():
		current_tween.kill()  # Останавливаем предыдущий твин, если он активен

	show()  # Показываем CanvasLayer

	current_tween = get_tree().create_tween()  # Создаем новый Tween-объект
	# Позволяет выполнять несколько анимаций одновременно

	# Анимация альфа-канала BaseColorRect до полной непрозрачности
	(
		current_tween
		. tween_property(base_color_rect, "color", fade_to_color, duration)
		. set_ease(Tween.EASE_IN_OUT)
		. set_trans(Tween.TRANS_QUAD)
	)

	# Анимация параметра шума в шейдере
	if noise_color_rect.material is ShaderMaterial:
		var shader_material = noise_color_rect.material as ShaderMaterial
		# Убедимся, что шум начинается с 0
		shader_material.set_shader_parameter("noise_amount", 0.0)

		current_tween.set_parallel(true)  # Анимируем несколько свойств одновременно
		# Анимируем noise_amount до пикового значения за половину времени ослепления
		(
			current_tween
			. tween_property(
				shader_material, "shader_parameter/noise_amount", noise_peak_amount, duration * 0.5
			)
			. set_ease(Tween.EASE_OUT)
		)  # Быстрое нарастание

	# После завершения всех анимаций вызываем _on_blinding_complete
	# current_tween.tween_callback(_on_blinding_complete)
	# Подключаем сигнал finished для очистки ссылки на Tween
	current_tween.connect("finished", _on_blinding_complete, CONNECT_ONE_SHOT)


func _on_blinding_complete():
	print("Blinding effect finished")
	print_debug(base_color_rect.color)
	emit_signal("blind_finished")  # Испускаем сигнал о завершении


# Функция для "раз-ослепления" (плавного появления в новой сцене)
func start_unblinding(duration: float = 1.0, fade_from_color: Color = Color(1.0, 1.0, 1.0, 0.96)):
	if current_tween != null and current_tween.is_running():
		current_tween.kill()

	show()  # Убедимся, что эффект виден
	base_color_rect.color = fade_from_color  # Устанавливаем начальный цвет (например, полностью белый)

	current_tween = get_tree().create_tween()

	# Анимация альфа-канала BaseColorRect до полной прозрачности
	(
		current_tween
		. tween_property(
			base_color_rect,
			"color",
			Color(fade_from_color.r, fade_from_color.g, fade_from_color.b, 0.0),
			duration
		)
		. set_ease(Tween.EASE_IN_OUT)
		. set_trans(Tween.TRANS_QUAD)
	)

	# Анимация параметра шума в шейдере до 0.0
	if noise_color_rect.material is ShaderMaterial:
		var shader_material = noise_color_rect.material as ShaderMaterial
		current_tween.set_parallel(true)
		# Анимируем noise_amount до 0.0 за половину времени раз-ослепления
		(
			current_tween
			. tween_property(shader_material, "shader_parameter/noise_amount", 0.0, duration * 0.5)
			. set_ease(Tween.EASE_IN)
		)  # Медленное затухание

	# current_tween.tween_callback(Callable(self, "_on_unblinding_complete"))
	current_tween.connect("finished", _on_unblinding_complete, CONNECT_ONE_SHOT)


func _on_unblinding_complete():
	print("Unblinding effect finished.")
	hide()  # Скрываем эффект после завершения
	emit_signal("unblind_finished")


func _on_tween_finished():
	print_debug("BlindingEffect: _on_tween_finished() called.")
	current_tween = null  # Обнуляем ссылку, чтобы Tween-объект мог быть освобожден памятью


func kill_tween():
	if current_tween != null and current_tween.is_running():
		current_tween.kill()
		print_debug("BlindingEffect: _kill_tween() called.")


func _exit_tree():
	kill_tween()
