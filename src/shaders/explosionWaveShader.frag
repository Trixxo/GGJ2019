uniform vec2 camera_pos;

uniform float time;

uniform float impact_time[4];
uniform vec2 impact_coords[4];

const float pi = 3.1415926535;
const float default_wave_width = 100.0f;
const float distortion_strength = 10.0f;

const float screen_width = 1200.0f;
const float screen_height = 800.0f;

float get_relative_distortion(float wave_peak_distance, float wave_width, float point_distance) {
    float relative_distane = (point_distance - wave_peak_distance) / wave_width;
    float x = 2.0f * pi * clamp(relative_distane, -1.0f, 1.0f);
    float sin_x_by_4 = sin(x * 0.25);
    return (-cos(x) * 0.5 + 0.5) * sin_x_by_4 / abs(sin_x_by_4);
}

vec2 get_absolute_distortion(int i, vec2 pixel) {
    vec2 impact = impact_coords[i] - camera_pos;
    float elapsed_time = time - impact_time[i];
    if (elapsed_time < 0.0) {
        return vec2(0.0);
    }
    float peak_dist = 5000 * elapsed_time;

    vec2 impact_to_pixel = impact - pixel;
    float pixel_dist = length(impact_to_pixel);
    vec2 direction = impact_to_pixel / pixel_dist;
    float rel_distortion = get_relative_distortion(peak_dist, default_wave_width, pixel_dist);
    return distortion_strength * rel_distortion * direction;
}

vec4 get_frag_at_screen_pos(Image screen, vec2 screen_coords) {
    float tex_x = screen_coords.x / screen_width;
    float tex_y = screen_coords.y / screen_height;
    return Texel(screen, vec2(tex_x, tex_y));
    /* return vec4(tex_x, 0.0, tex_y, 1.0); */
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 final_coords = screen_coords;
    for (int i = 0; i < 4; i++) {
        final_coords += get_absolute_distortion(i, screen_coords);
    }
    vec4 a = get_frag_at_screen_pos(texture, final_coords) * color * 0.0000001;
    return vec4(screen_coords.x / screen_width, 0.0,0.0,1.0) + 0.0* a;
}