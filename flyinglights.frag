{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sl280\partightenfactor0

\f0\fs24 \cf2 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 \
\
#ifdef GL_ES\
precision mediump float;\
#endif\
 \
uniform float time;\
varying vec2 surfacePosition;\
 \
#define PI 3.14159265358979\
#define N 10\
void main( void ) \{\
	float size = 0.25;\
	float dist = 0.100;\
	float ang = 0.0;\
	vec2 pos = vec2(0.0,0.0);\
	vec3 color = vec3(0.1);;\
	\
	for(int i=0; i<N; i++)\{\
		float r = 0.3;\
		ang += PI / (float(N)*0.5)+(time/60.0);\
		pos = vec2(cos(ang),sin(ang))*r*sin(time+ang/.3);				  \
		dist += size / distance(pos,surfacePosition);\
		vec3 c = vec3(0.03, 0.05, 0.1);\
		color = c*dist;\
	\}\
	gl_FragColor = vec4(color, 1.0);\
\}\
}