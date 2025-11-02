#version 330 core

const float pi = 3.141592;

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 3) in vec2 texturePosition;

uniform mat4 modelViewProjectionMatrix;

// Radi de la circumferència centrada al vèrtex
// i continguda al pla descrit per la normal del vèrtex.
uniform float d = 0.02;
uniform float time;
uniform float frequency = 0.9;

out vec2 vertTexturePosition;

vec3 rotate(vec3 P, float angle, vec3 axis) {
	float s = sin(angle);
	float c = cos(angle);
	float d = 1 - c;
	float xx = axis.x * axis.x;
	float yy = axis.y * axis.y;
	float zz = axis.z * axis.z;
	float xs = axis.x * s;
	float ys = axis.y * s;
	float zs = axis.z * s;
	float xyd = axis.x * axis.y * d;
	float xzd = axis.x * axis.z * d;
	float yzd = axis.y * axis.z * d;
	return mat3(
		xx * d + c, xyd - zs, xzd + ys,
		xyd + zs, yy * d + c, yzd - xs,
		xzd - ys, yzd + xs, zz * d + c) * P;
}

vec3 perpendicular(vec3 V) {
	if (V.x > 0) return vec3(V.y, -V.x, 0);
	else if (V.y > 0) return vec3(0, V.z, -V.y);
	else return vec3(-V.z, 0, V.x);
}

void main() {
	// Vector que descriu la orientació del pla que conté el vèrtex.
	vec3 N = normal;
	// Vector tangent al pla descrit per la normal del vèrtex.
	vec3 T = normalize(perpendicular(N));
	float phi = dot(vec2(2 * pi), texturePosition);
	float angle = phi + frequency * time;
	vec3 circumferencePosition = position + rotate(T * d, angle, N);
	gl_Position = modelViewProjectionMatrix * vec4(circumferencePosition, 1.0);
	vertTexturePosition = texturePosition;
}
