#version 330 core

const float planeDepth = -1.5;

layout (location = 0) in vec3 position;
layout (location = 3) in vec2 texturePosition;

out vec3 vertPosition;
out vec2 vertTexturePosition;

uniform mat4 modelViewProjectionMatrix;
uniform float time;

void main() {
	vec3 P = position;

	if (position.z == planeDepth) {
		float s = sin(time);
		P.z -= s * s;
	}
	
	vertPosition = position;
	vertTexturePosition = texturePosition;
	gl_Position = modelViewProjectionMatrix * vec4(P, 1.0);
}
