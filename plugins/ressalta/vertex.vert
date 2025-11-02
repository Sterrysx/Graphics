#version 330 core
layout (location=0) in vec3 vertex;
layout (location=2) in vec3 color;
uniform mat4 modelViewProjectionMatrix;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
out vec4 FrontColor;

void main() {

    float x = boundingBoxMax.x - boundingBoxMin.x;
    float y = boundingBoxMax.y - boundingBoxMin.y;
    float z = boundingBoxMax.z - boundingBoxMin.z;  

    mat4 scale = mat4(vec4(x,0,0,0), vec4(0,y,0,0), vec4(0,0,z,0), vec4(0,0,0,1));
    FrontColor=vec4(color, 1);
    vec3 centre = vec3(boundingBoxMin.x, boundingBoxMin.y, boundingBoxMin.z);
    mat4 translation = mat4(vec4(1,0,0,0),vec4(0,1,0,0), vec4(0,0,1,0), vec4(centre,1));
    
    gl_Position=modelViewProjectionMatrix*translation*scale*vec4(vertex,1);
}
