shader_type canvas_item;

uniform float noise_amount : hint_range(0.0, 1.0) = 0.0;
uniform float noise_scale : hint_range(1.0, 200.0) = 150.0;
uniform vec4 noise_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453 + TIME);
}

void fragment() {
    vec2 noise_coord = FRAGCOORD.xy / noise_scale;

    float r = rand(noise_coord);

    vec4 final_noise_fragment_color = vec4(noise_color.rgb, r * noise_color.a * noise_amount);
    
    COLOR = final_noise_fragment_color;
}