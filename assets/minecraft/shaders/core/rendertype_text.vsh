#version 150
#define PI 3.1415926535

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform float GameTime;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
//uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

out float drawRed;
out vec2 coords;
out float intensity;
out float fade;
out float fade_color;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    drawRed = 0.0;
    fade_color = -1000;

    if (Color.r == 3.0/255.0 && Color.g == 6.0/255.0 && Color.b == 1.0/255.0){
        gl_Position.y += sin(radians((gl_Position.x + 1 + GameTime * 10) * 3600)) / 100;
        gl_Position.x += cos(radians(GameTime * 36000)) / 100;
        
        vertexColor = vec4(1, 0.2, 0.2, vertexColor.a);
    } else if (Color.r == 4.0/255.0 && Color.g < 10.0/255.0 && Color.b == 1.0/255.0) {
        intensity = 0.0;
        switch(gl_VertexID % 4) {
            case 0:
                gl_Position.xy = vec2(-1, 1);
                break;
            case 1:
                gl_Position.xy = vec2(-1, -1);
                break;
            case 2:
                gl_Position.xy = vec2(1, -1);
                break;
            case 3:
                gl_Position.xy = vec2(1, 1);
                break;
            default:
                vertexColor.rgb = vec3(1, 1, 1);
                break;
        }
        
        intensity = Color.g * 38.25;
        coords = gl_Position.xy;

        drawRed = Color.g * 255;
    } else if (Color.r == 5.0/255.0 && Color.b == 1.0/255.0) {
        switch(gl_VertexID % 4) {
            case 0:
                fade = 1.0;
                break;
            case 1:
                fade = 0.0;
                break;
            case 2:
                fade = 0.0;
                break;
            case 3:
                fade = 1.0;
                break;
        }
        fade_color = Color.g;
    }
}
