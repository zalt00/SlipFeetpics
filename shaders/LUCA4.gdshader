shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;

uniform float edge_threshold = 0.2;
uniform vec3 line_color: source_color = vec3(0.043, 0.282, 0.467);
uniform vec3 background_color: source_color = vec3(0.408, 0.969, 0.694);

uniform sampler2D DEPTH_TEXTURE: hint_depth_texture, filter_linear_mipmap;

const mat3 sobel_y = mat3(
	vec3(1.0, 0.0, -1.0),
	vec3(2.0, 0.0, -2.0),
	vec3(1.0, 0.0, -1.0)
);

const mat3 sobel_x = mat3(
	vec3(1.0, 2.0, 1.0),
	vec3(0.0, 0.0, 0.0),
	vec3(-1.0, -2.0, -1.0)
);

void vertex(){
	//POSITION = vec4(VERTEX, 1.0);
}


float linearize_depth(vec2 uv_coord, mat4 proj_matrix){
	float depth = texture(DEPTH_TEXTURE, uv_coord).x;
	vec3 ndc = vec3(uv_coord, depth) * 2.0 - 1.0;
	vec4 view = proj_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return linear_depth;
}




void fragment() {
	
	vec2 uv = SCREEN_UV;
	vec4 screen_color = texture(SCREEN_TEXTURE, uv);
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	normal = normal * 2.0 - 1.0;
	vec2 offset = 1.0 / VIEWPORT_SIZE;

	vec3 n = texture(NORMAL_TEXTURE, uv + vec2(0.0, -offset.y)).rgb;
	vec3 s = texture(NORMAL_TEXTURE, uv + vec2(0.0, offset.y)).rgb;
	vec3 e = texture(NORMAL_TEXTURE, uv + vec2(offset.x, 0.0)).rgb;
	vec3 w = texture(NORMAL_TEXTURE, uv + vec2(-offset.x, 0.0)).rgb;
	vec3 nw = texture(NORMAL_TEXTURE, uv + vec2(-offset.x, -offset.y)).rgb;
	vec3 ne = texture(NORMAL_TEXTURE, uv + vec2(offset.x, -offset.y)).rgb;
	vec3 sw = texture(NORMAL_TEXTURE, uv + vec2(-offset.x, offset.y)).rgb;
	vec3 se = texture(NORMAL_TEXTURE, uv + vec2(offset.x, offset.y)).rgb;

	mat3 surrounding_pixels = mat3(
		vec3(length(nw-normal), length(n-normal), length(ne-normal)),
		vec3(length(w-normal), length(normal-normal), length(e-normal)),
		vec3(length(sw-normal), length(s-normal), length(se-normal))
	);

	float edge_x = dot(sobel_x[0], surrounding_pixels[0]) + dot(sobel_x[1], surrounding_pixels[1]) + dot(sobel_x[2], surrounding_pixels[2]);
	float edge_y = dot(sobel_y[0], surrounding_pixels[0]) + dot(sobel_y[1], surrounding_pixels[1]) + dot(sobel_y[2], surrounding_pixels[2]);

	float edge = sqrt(pow(edge_x, 2.0)+pow(edge_y, 2.0));

	//truc2
	

	float depth = linearize_depth(uv, INV_PROJECTION_MATRIX);


	float dn = linearize_depth(uv + vec2(0.0, -offset.y), INV_PROJECTION_MATRIX);
	float ds = linearize_depth(uv + vec2(0.0, offset.y), INV_PROJECTION_MATRIX);
	float de = linearize_depth(uv + vec2(offset.x, 0.0), INV_PROJECTION_MATRIX);
	float dw = linearize_depth(uv + vec2(-offset.x, 0.0), INV_PROJECTION_MATRIX);
	float dnw = linearize_depth(uv + vec2(-offset.x, -offset.y), INV_PROJECTION_MATRIX);
	float dne = linearize_depth(uv + vec2(offset.x, -offset.y), INV_PROJECTION_MATRIX);
	float dsw = linearize_depth(uv + vec2(-offset.x, offset.y), INV_PROJECTION_MATRIX);
	float dse = linearize_depth(uv + vec2(offset.x, offset.y), INV_PROJECTION_MATRIX);

	mat3 d_surrounding_pixels = mat3(
		vec3(dnw, dn, dne),
		vec3(dw, depth, de),
		vec3(dsw, ds, dse)
	);

	float d_edge_x = dot(sobel_x[0], d_surrounding_pixels[0]) + dot(sobel_x[1], d_surrounding_pixels[1]) + dot(sobel_x[2], d_surrounding_pixels[2]);
	float d_edge_y = dot(sobel_y[0], d_surrounding_pixels[0]) + dot(sobel_y[1], d_surrounding_pixels[1]) + dot(sobel_y[2], d_surrounding_pixels[2]);

	float d_edge = sqrt(pow(d_edge_x, 2.0)+pow(d_edge_y, 2.0));
	
	if (edge > edge_threshold || (edge == 0.0 && d_edge > edge_threshold*depth)) {
		ALBEDO = line_color;
	} else {
		ALBEDO = background_color;
	}
	
	
	
	
	
	
	
	
	
	
	
}