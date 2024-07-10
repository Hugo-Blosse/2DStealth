shader_type canvas_item;

uniform bool damaged = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (damaged)
	{
		vec4 color = texture(TEXTURE, UV);
		//float color_average = (color.r + color.g + color.b) / 3.0
		COLOR = vec4(1.0, 1.0, 1.0, color.a);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
