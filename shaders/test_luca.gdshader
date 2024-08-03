shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;

uniform float edge_threshold = 0.2;
uniform vec3 line_color: source_color = vec3(0.043, 0.282, 0.467);
uniform vec3 background_color: source_color = vec3(0.408, 0.969, 0.694);

uniform sampler2D DEPTH_TEXTURE: hint_depth_texture, filter_linear_mipmap;
uniform vec3 shadow_color : source_color = vec3(0.0);
uniform float shadow_thickness = 2.0;

uniform bool truc = false;


vec2 getDepth(vec2 screen_uv, sampler2D depth_texture, mat4 inv_projection_matrix){
	float raw_depth = texture(depth_texture, screen_uv)[0];
	vec3 normalized_device_coordinates = vec3(screen_uv * 2.0 - 1.0, raw_depth);
    vec4 view_space = inv_projection_matrix * vec4(normalized_device_coordinates, 1.0);	
	view_space.xyz /= view_space.w;	
	return vec2(-view_space.z, raw_depth);
}

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
	float edge;
	{vec2 uv = SCREEN_UV;
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

	edge = sqrt(pow(edge_x, 2.0)+pow(edge_y, 2.0));
	}
	//truc2
	

	vec2 e = vec2(1./VIEWPORT_SIZE.xy)*1.0;

	float depth_diff = 0.0;
	float neg_depth_diff = .5;
	
	vec2 depth_data = getDepth(SCREEN_UV, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);
	float depth = depth_data.x;
	vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec3 c = vec3(0.0);
	
	vec2 min_depth_data = depth_data;
	float min_depth = 9999999.9;
	
	vec2 z_data = getDepth(SCREEN_UV, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);

	vec3 normal = texture(NORMAL_TEXTURE, SCREEN_UV).rgb * 2.0 - 1.0;
	
	for (float x = -shadow_thickness; x <= shadow_thickness;x += 1.0){
		for (float y = -shadow_thickness; y <= shadow_thickness; y += 1.0){
			if ((x == 0.0 && y == 0.0) || (shadow_thickness*shadow_thickness < (x*x + y*y))){
				continue;
			}
			
			vec2 du_data = getDepth(SCREEN_UV+1.0*vec2(x, y)*e, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);
			vec2 dd_data = getDepth(SCREEN_UV+0.5*vec2(x, y)*e, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);
			
			float du = du_data.x;
			float dd = dd_data.x;
			
			//float dd_diff = clamp(abs((depth - dd) - (dd - du)), 0.0, 1.0);
			float dd_diff = clamp((depth - dd) - (dd - du), -1.0, 1.0);

			float val = clamp(depth - du, -1., 1.)/(x*x + y*y)*dd_diff*dd_diff*5000.0;
			
			val = clamp(val, -1.0, 1.0);
			if (truc) {
				val = abs(val);
			}
			depth_diff += val;

			if (du < min_depth){
				min_depth = du;
				min_depth_data = du_data;
				c = texture(SCREEN_TEXTURE, SCREEN_UV+vec2(x, y)*e).rgb;
				
				c *= clamp(0.5+ 0.5*dot(normalize(vec2(x, y)), (vec2(0.0, 1.0))), 0.0, 1.0);
				
			}
			
			vec3 nu = texture(NORMAL_TEXTURE, SCREEN_UV+vec2(x, y)*e).rgb * 2.0 - 1.0;
			
			depth_diff += (1.0-abs(dot(nu, normal)))/max(min(dd, depth), 2.0);
		}
	}
	depth_diff = abs(depth_diff);
	
	float min_step = max(0.3, depth / 50.0);
	
	depth_diff = smoothstep(min_step, min_step + 1.0, depth_diff);

	vec3 final = c*shadow_color;
	
	
	ALBEDO = final;
	
	
	
	
	
	
	
	
	
	
	
}