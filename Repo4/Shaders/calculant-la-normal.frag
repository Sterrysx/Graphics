#version 330 core

in vec3 eyeVertex;
in vec3 vertexColor;

out vec4 fragColor;

vec3 normal(vec3 A) {
	vec3 AB = dFdx(A);
	vec3 AC = dFdy(A);
	return normalize(cross(AB, AC));
}

void main() {
	fragColor = vec4(vertexColor * normal(eyeVertex).z, 1.0);
}
