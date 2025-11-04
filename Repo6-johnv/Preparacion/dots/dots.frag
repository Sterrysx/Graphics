#version 330 core

in vec4 gfrontColor;
out vec4 fragColor;
in vec3 P;
in vec3 C;
uniform float size = 0.02;
uniform bool opaque = true;
const vec4 blanco = vec4(1.0);
void main()
{
    float d = distance(P,C);
    if (d <size){
    fragColor = gfrontColor ;

        }
    else{
        if (opaque){
            fragColor= blanco;
        }
        else{
            discard;
        }

    }
        
        
}
