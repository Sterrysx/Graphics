#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

uniform mat4 modelViewProjectionMatrix;
uniform float time;

out vec4 gfrontColor;
out vec2 st;

vec3 cubeVerts[8] = vec3[](
    vec3(-1,-1,-1), vec3(1,-1,-1), vec3(-1,1,-1), vec3(1,1,-1),
    vec3(-1,-1,1), vec3(1,-1,1), vec3(-1,1,1), vec3(1,1,1)
);

int cubeFaces[36] = int[](
    0,1,2,  2,1,3,  // cara -Z (back, blanca)
    4,6,5,  5,6,7,  // cara +Z (front, groga)
    0,2,4,  4,2,6,  // cara -X (left, verda)
    1,5,3,  3,5,7,  // cara +X (right, blava)
    2,3,6,  6,3,7,  // cara +Y (top, vermella)
    0,4,1,  1,4,5   // cara -Y (bottom, taronja)
);

// Funció per determinar color segons la normal
vec4 colorPerNormal(vec3 n) {
    if (n.y < -0.9) return vec4(1, 0.6, 0, 1); // bottom - taronja
    if (n.y >  0.9) return vec4(1, 0, 0, 1);   // top - vermell
    if (n.x < -0.9) return vec4(0, 1, 0, 1);   // left - verd
    if (n.x >  0.9) return vec4(0, 0, 1, 1);   // right - blau
    if (n.z < -0.9) return vec4(1, 1, 1, 1);   // back - blanc
    if (n.z >  0.9) return vec4(1, 1, 0, 1);   // front - groc
    return vec4(0, 0, 0, 1); // fallback (no hauria passar)
}

// Matriu de rotació Z
mat4 rotZ(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat4(
        c, -s, 0, 0,
        s,  c, 0, 0,
        0,  0, 1, 0,
        0,  0, 0, 1
    );
}

void main() {
    if (gl_PrimitiveIDIn >= 8) return;

    vec3 center = cubeVerts[gl_PrimitiveIDIn];
    mat4 rotation = mat4(1.0);
    if (gl_PrimitiveIDIn < 4) {
        rotation = rotZ(time);
    }

    float s = 1.0; // la meitat de la mida (cubs de costat 2)

    for (int i = 0; i < 36; i += 3) {
        vec3 v0 = cubeVerts[cubeFaces[i]];
        vec3 v1 = cubeVerts[cubeFaces[i + 1]];
        vec3 v2 = cubeVerts[cubeFaces[i + 2]];

        vec3 normal = normalize(cross(v1 - v0, v2 - v0));
        gfrontColor = colorPerNormal(normal);

        for (int j = 0; j < 3; ++j) {
            vec3 v = cubeVerts[cubeFaces[i + j]];
            vec3 worldPos = center + s * (rotation * vec4(v, 1.0)).xyz;

            gl_Position = modelViewProjectionMatrix * vec4(worldPos, 1.0);
            st = (v.xy + vec2(1.0)) * 0.5; // per marginat
            EmitVertex();
        }
        EndPrimitive();
    }
}
