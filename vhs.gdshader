shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest; // ← NEAREST!

// Упрощённые параметры
uniform float wave_speed : hint_range(0,2) = 0.3;
uniform float color_shift : hint_range(0,0.01) = 0.003;

float quick_noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;
	uv = floor(uv * 700.0) / 700.0; // Пикселизация маскирует артефакты


    // Оптимизированные волны
    float wave = quick_noise(vec2(uv.y * 50.0, TIME * wave_speed)) - 0.5;
    uv.x += wave * 0.005;

    // Цветовой сдвиг (дешевле оригинала)
    vec3 col;
    col.r = texture(SCREEN_TEXTURE, uv + vec2(color_shift, 0.0)).r;
    col.g = texture(SCREEN_TEXTURE, uv).g;
    col.b = texture(SCREEN_TEXTURE, uv - vec2(color_shift, 0.0)).b;

    // Стильные сканирующие линии
    col *= 1.0 + 0.1 * sin(uv.y * 1000.0 + TIME * 2.0);

    COLOR = vec4(col, 1.0);
}
