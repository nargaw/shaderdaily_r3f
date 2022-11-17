varying vec2 vUv;
#define TWO_PI 6.28318530718
uniform float u_time;

mat2 Rot(float a){
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

void main(){
    vec2 vUv = vec2(vUv.x, vUv.y);
    vUv -= 0.5;
    vUv *= 10.0;
    float t = u_time * .05;
    vUv *= Rot(t * 5.0);
    vec3 color = vec3(0.);
    float radius = length(tan(vUv + (sin(vUv.y))) * 0.08);
    color = vec3(tan(vUv.x + cos(vUv.y + u_time)), tan(1. - vUv.x + cos(vUv.y + u_time)), tan(vUv.x + cos(vUv.y + u_time)));
    vec3 newColor = vec3(color.x * radius, color.y * radius, color.z * radius);
    gl_FragColor = vec4(newColor, 1.);
}