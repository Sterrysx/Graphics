#version 330 core

in vec4 gfrontColor;
out vec4 fragColor;

in vec2 st;

const vec4 black =vec4(0,0,0,1.0);
void main()
{
      if (st.x < 0.05 || st.x > 0.95 || st.y < 0.05 || st.y > 0.95)
        fragColor = black; // negro
    else
        fragColor = gfrontColor;
}
