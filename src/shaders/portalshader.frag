uniform vec2 display_size;
uniform vec2 camera_pos;
uniform vec2 portal_pos;

uniform float time;

const float pi = 3.1415926535;
const float distortion_strength = 10.0f;
const float portal_radius = 1000;


float get_relative_distortion(float wave_peak_distance, float wave_width, float point_distance) {
    float relative_distane = (point_distance - wave_peak_distance) / wave_width;
    float x = 2.0f * pi * clamp(relative_distane, -1.0f, 1.0f);
    float sin_x_by_4 = sin(x * 0.25);
    return (-cos(x) * 0.5 + 0.5) * sin_x_by_4 / abs(sin_x_by_4);
}

vec4 get_frag_at_screen_pos(Image screen, vec2 screen_coords) {
    float tex_x = screen_coords.x / display_size.x;
    float tex_y = screen_coords.y / display_size.y;
    return Texel(screen, vec2(tex_x, tex_y));
    /* return vec4(tex_x, 0.0, tex_y, 1.0); */
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {

    vec2 center = portal_pos - camera_pos;
    vec2 center_to_pixel = center - screen_coords;
    float pixel_dist = length(center_to_pixel);

    float radius_strength = 1.0f - clamp(abs((0.5 * portal_radius - pixel_dist) / (0.5 * portal_radius)), 0.0f, 1.0f);

    float f = time * 100 * screen_coords.x * screen_coords.y;
    vec2 distortion = vec2(sin(f), cos(f));
    vec2 final_coords = screen_coords + radius_strength * distortion_strength * distortion;

    vec4 normal = get_frag_at_screen_pos(texture, final_coords) * color;
    vec4 grey = vec4(vec3((normal.r + normal.g + normal.b) / 3.0f), normal.a);
    return grey * radius_strength + normal * (1 - radius_strength);
}
