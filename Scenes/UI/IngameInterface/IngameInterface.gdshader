shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform float strength : hint_range(0.0, 1.0) = 1.0;

uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float border_px : hint_range(0.0, 64.0) = 0.0;
uniform float rect_size : hint_range(1.0, 4096.0) = 128.0;

void fragment() {
    vec4 src = texture(TEXTURE, UV);
    vec3 tinted = mix(src.rgb, tint_color.rgb, strength);
    float alpha = src.a * tint_color.a;

    // pixel coordinates inside control
    vec2 p = UV * rect_size;

    // border masks for each side
    float left   = step(p.x, border_px);
    float right  = step(rect_size - border_px, p.x);
    float top    = step(p.y, border_px);
    float bottom = step(rect_size - border_px, p.y);

    float is_border = clamp(left + right + top + bottom, 0.0, 1.0);

    // blend: border overrides tint
    vec3 out_rgb = mix(tinted, border_color.rgb, is_border);
    float out_a = mix(alpha, border_color.a, is_border);

    COLOR = vec4(out_rgb, out_a);
}