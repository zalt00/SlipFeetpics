shader_type spatial;
render_mode world_vertex_coords, wireframe, cull_disabled, shadows_disabled, unshaded;
#include "funcs.gdshaderinc"

uniform float lines1:hint_range(0.0, 200.0, 1.0) = 2.0;
uniform float lines2:hint_range(0.0, 100.0, 1.0) = 2.0;
uniform vec3 color: source_color;

uniform float _emission:hint_range(0.0, 10.0 ) = 1.0;
uniform float _frensel:hint_range(0.0, 10.0 ) = 1.0;

uniform float _glitch_intensity:hint_range(0.04, 3.0, 0.01);
uniform float _th:hint_range(0.0, 1.0, 0.01);

varying float rand_dist;



void vertex() {
	float distorsion = sin(TIME*10.0+VERTEX.y*20.0)*_glitch_intensity;
	
	float rand_time = random(TIME);
	rand_dist = step(rand_time, 0.001);
	
	
	VERTEX.x += distorsion * rand_dist;

}


void fragment() {
	float n = random2_1(SCREEN_UV);
	float f = fresnel(_frensel, NORMAL, VIEW);
	
	vec2 igrid = floor(SCREEN_UV * lines1);
	
	float l1 = mod(igrid.y, 2.0);
	l1 = mix(0.4, 1.0, l1);
	
	vec2 uv2 = SCREEN_UV;
	uv2.y -= TIME * 0.06;
	vec2 igrid2 = floor(uv2*lines2);
	float l2 = random(igrid2.y);
	l2 = step(0.05, l2);
	l2 = mix(0.6, 1.0, l2);
	
	float m = f*n*l1*l2;
	//ALBEDO = vec3(m);
	float s = (0.6 + sin(length(VERTEX)*10.0)*0.0);
	

	ALPHA = s*step(_th, length(VERTEX));
	ALBEDO = color;
	//ALBEDO = color*mix(_emission, _emission + 2.0, rand_dist);
	//ALBEDO = vec3(l2);
}


//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
