#version 330 core

const float epsilon = 0.000001;

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform vec3 center = vec3(0);

bool pointIsInsideCube(vec3 point, float radius) {
	vec3 difference = abs(point) - vec3(radius);
	return difference.x <= epsilon &&
	       difference.y <= epsilon &&
	       difference.z <= epsilon;
}

bool vectorIntersectsPlaneOnce(vec3 vector, vec3 planeNormal) {
	return dot(normalize(vector), planeNormal) > 0;
}

vec3 vectorPlaneIntersectionPoint(vec3 origin, vec3 vector, vec3 planeNormal) {
	float d = dot(planeNormal - origin, planeNormal) / dot(vector, planeNormal); 
	return vector * d; 
}

vec3 cubeProjection(vec3 point, float radius) {
	vec3 faces[6];
	faces[0] = vec3(1, 0, 0);
	faces[1] = vec3(-1, 0, 0);
	faces[2] = vec3(0, 0, 1);
	faces[3] = vec3(0, 0, -1);
	faces[4] = vec3(0, 1, 0);
	faces[5] = vec3(0, -1, 0);
	for (int i = 0; i < 6; i++) {
		vec3 vector = normalize(vertex);
		if (vectorIntersectsPlaneOnce(vector, faces[i])) {
			vec3 point = vectorPlaneIntersectionPoint(center, vector, faces[i]);
			if (pointIsInsideCube(point, radius))
				return point;
			}
	}
}

void main() {
	frontColor = vec4(color, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(cubeProjection(vertex, 1), 1.0);
}
