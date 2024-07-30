shader_type spatial;
uniform float strength;

void fragment() {
	ALBEDO = vec3(1.0, 1.0, 0.0);
	ALPHA = strength;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
