#version 330 core

in vec4 frontColor;
out vec4 fragColor;
const vec4 negro= vec4(0,0,0,1.0);
const vec4 blanco= vec4(1.0);
uniform int mode = 2;
void main()
{
  float intensidad = frontColor.r;

     if (mode == 2){
        int x = int(gl_FragCoord.x);
        int y = int(gl_FragCoord.y);

        if (mod(x,2) == 0 && mod(y,2) == 0){
            intensidad -= 0.5;
        }
        else if (mod(x,2) == 0 && mod(y,2) != 0){
            intensidad +=0.25;
        }
         else if (mod(x,2) != 0 && mod(y,2) != 0){
            intensidad -=0.25;
            
        }
    }
   
        if (intensidad < 0.5) fragColor = negro;
        else fragColor = blanco;
    
    
}
