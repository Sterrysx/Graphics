#version 330 core

in vec3 vertColor;
in vec3 vertPosition;

out vec3 fragColor;

uniform vec3 planeNormal = vec3(1, 1, 0);
uniform float planeOffset = 0.1;

float distanceToPlane(vec3 P, vec3 N, float d) {
	return dot(N, P) - d;
}

void main() {
	float d = distanceToPlane(vertPosition, planeNormal, planeOffset);
	if (d > 0) discard;
	else fragColor = vertColor;
}
