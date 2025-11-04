#version 330 core

in vec4 frontColor;
out vec4 fragColor;
in vec2 vtexCoord;
uniform sampler2D window;
uniform sampler2D palm1;  // observeu el dígit 1 al final
uniform sampler2D background2; // observeu el dígit 2 al final
in vec3 N_a;
uniform float time;
void main()
{
    fragColor = frontColor;
    //window
    vec4 C = texture(window, vtexCoord);
    //palmera
    vec3 N = normalize(N_a);
    vec2 D_aux= vtexCoord + 0.25*N.xy + vec2(0.1*sin(2*time)*vtexCoord.t, 0);
    vec4 D = texture(palm1, D_aux);
    
    if (C.a == 1.0) fragColor = C;
    else if (D.a >= 0.5){
        fragColor= D;
    }
     //fondo
    else fragColor = texture(background2,vtexCoord + 0.5*N.xy);
    
;
}
