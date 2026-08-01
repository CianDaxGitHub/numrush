extends Control

@onready var carousel: CarouselContainer = %Carousel

@onready var developers: Label = %developers
@onready var particles = %GPUParticles2D

func _on_btn_left_pressed() -> void:
	carousel.selected_index = 0
	developers.text = "Developers"

func _on_btn_right_pressed() -> void:
	carousel.selected_index = 1
	developers.text = "Contributors"


func _on_btn_back_pressed() -> void:
	var tween = particles.create_tween()
	tween.tween_property(particles, "modulate", Color(1.0, 1.0, 1.0, 0.4), 1.2)
