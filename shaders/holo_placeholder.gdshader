shader_type spatial;
render_mode world_vertex_coords, cull_disabled, shadows_disabled, unshaded;
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
	//ALBEDO = vec3(m);
	float s = (0.3 + sin(length(VERTEX)*10.0)*0.0);
	
	float d = step(0.1, abs(abs(VERTEX.x) - abs(VERTEX.y)));
	float st = step(8.49, abs(VERTEX.z));
	
	float b = 1.0-step(2.6, max(abs(VERTEX.x), abs(VERTEX.y)));
	
	ALPHA = s*step(_th, length(VERTEX))*(d*(1.0-st) + st*b);
	ALBEDO = color;
	//ALBEDO = color*mix(_emission, _emission + 2.0, rand_dist);
	//ALBEDO = vec3(l2);
}


//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
