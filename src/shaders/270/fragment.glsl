varying vec2 vUv;
#define PI 3.14159265359
#define TWO_PI 6.28318530718
uniform float u_time;
uniform vec2 u_mouse;


//book of shaders example
float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

#define NUM_OCTAVES 5

float fbm(vec2 vUv){
    float v = 0.;
    float a = 0.6;
    vec2 shift = vec2(100.);
    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.5));
    for(int i = 0; i < NUM_OCTAVES; i++){
        v += a * noise(vUv);
        vUv = rot * vUv * 2.0 + shift + (u_time * 0.05);
        a *= 0.5;
    }
    return v;
}

void main(){
    vec2 vUv = vec2(vUv.x, vUv.y);
    vUv *= 1.5;
    vUv.x += u_time * 0.1;
    vec3 color = vec3(0.);

    vec2 q = vec2(0.);
    q.x = fbm(vUv + 0.2 * u_time);
    q.y = fbm(vUv + vec2(1.));

    vec2 r = vec2(0.);
    r.x = fbm(vUv + 1.0 * q + vec2(1.7, 9.2) + 0.15 * u_time);
    r.y = fbm(vUv + 1.0 * q + vec2(8.3, 2.8) + 0.16 * u_time);

    float f = fbm(vUv + r);

    color = mix(vec3(0.101961,0.619608,0.666667),
                vec3(0.066667,0.666667,0.498039),
                clamp((f*f)*5.0,0.0,1.0));

    color = mix(color,
                vec3(0.,0.5,0.164706),
                clamp(length(q),0.0,1.0));

    color = mix(color,
                vec3(0.666667,1,1),
                clamp(length(r.x),0.0,.2));

    float x = f * f * f + 0.6 * f * f + 0.5 * f;


   gl_FragColor = vec4(color * x,1.);
}