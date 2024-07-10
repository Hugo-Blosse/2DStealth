shader_type canvas_item;

uniform bool stunned = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (stunned)
	{
		vec4 color = texture(TEXTURE, UV);
		COLOR = vec4(1, 1, color.g, color.a);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
