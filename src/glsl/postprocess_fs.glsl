#ifdef GL_ES
precision mediump float;
#endif

#define TWO_PI 6.283185307179586

uniform sampler2D data;
uniform vec2 resolution;
uniform float time;
varying vec2 vUv;

float random (in float x) {
    return fract(sin(x)*1e4);
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float pattern(vec2 st, vec2 v, float t) {
    vec2 p = floor(st+v);
    return step(t, random(100.+p*.000001)+random(p.x)*0.5 );
}

void main() {
    vec2 st = gl_FragCoord.xy / resolution.xy;
    vec4 src = texture2D(data, vUv);

    st.x *= resolution.x / resolution.y;

    vec2 grid = vec2(100.0,50.);
    st *= grid;

    vec2 ipos = floor(st);  // integer
    vec2 fpos = fract(st);  // fraction

    vec2 vel = vec2(time/10.*max(grid.x,grid.y)); // time
    vel *= vec2(-1.,0.0) * random(1.0+ipos.y); // direction

    // Assign a random value base on the integer coord
    vec2 offset = vec2(0.1,0.);

    vec3 color = vec3(0.);
    color.r = pattern(st+offset,vel,0.5+0.5/resolution.x);
    color.g = pattern(st,vel,0.5+0.5/resolution.x);
    color.b = pattern(st-offset,vel,0.5+0.5/resolution.x);

    // Margins
    color *= step(0.,fpos.y);

    // gl_FragColor = vec4( src.g, sin(st.x/100.0 + time/5.) * src.g, src.g/2.0, 1. );
    // gl_FragColor = vec4( src.ggg * color, 1. );
    gl_FragColor = vec4( src.ggg , 1. );
}