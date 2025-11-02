#version 330 core

in vec3 geomColor;
in vec2 geomTexturePosition;

out vec4 fragColor;

uniform sampler2D face;

void main() {
	if (geomTexturePosition.s >= 0 && geomTexturePosition.t >= 0) {
		fragColor = texture(face, geomTexturePosition);
	} else {
		fragColor = vec4(geomColor, 1);
	}
}
