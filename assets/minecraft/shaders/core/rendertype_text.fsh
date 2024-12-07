#version 150

#moj_import <fog.glsl>

#define SQR2 1.41421356237

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

in float drawRed; // ADDED
in vec2 coords;
in float intensity;
in float fade;
in float fade_color;

out vec4 fragColor;

vec4 get_fade_middle(vec3 colorTop, vec3 colorBottom, float a) {
    return vec4((colorTop - colorBottom) * fade + colorBottom, a);
}

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    if (drawRed > 0.5) {
        float dis = distance(coords, vec2(0, 0)) / SQR2;

        color = vec4(1, 0, 0, dis * intensity);
    } else if (fade_color > -1 && drawRed == 0.0) {
        int int_fade_color = int(fade_color * 255 + 0.5);

        switch (int_fade_color) {
            case 0:
            color = get_fade_middle(vec3(1, 0.75, 0.8), vec3(1, 1, 1), color.a);
            break;
            case 1:
            color = get_fade_middle(vec3(1.0), vec3(0.0), color.a);
            break;
            case 2:
            color = get_fade_middle(vec3(1.0, 0.82, 0.0), vec3(1.0, 0.41, 0.01), color.a);
            break;
            case 3:
            color = get_fade_middle(vec3(1.0, 0.27, 0.9), vec3(0.77, 0.01, 1.0), color.a);
            break;
        }
    }
    
    if (color.a < 0.1 && drawRed == 0.0) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}