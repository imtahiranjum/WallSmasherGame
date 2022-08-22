/*
// Procedural Surface Shaders
// Jonathan Cohen / ninjapretzel
// 2016-2017
// Noise Primitives

Distributed under MIT license
--------------------------------------------------------------------------------
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--------------------------------------------------------------------------------
*/

//This file defines:
//	Hook variables for generation
//	Helper functions to set the values
//	Simple Hash & Noise functions

#ifndef NOISEPRIMS_INCLUDED
#define NOISEPRIMS_INCLUDED
//LOL INCLUDE GUARDS

////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//Common noise components

//Standard random generation variables
//values are from hooks into material system
						//Recommended hooks are
int _Octaves; 			//_Octaves ("NoiseOctaves", Range(1, 32)) = 5.0
float _Seed; 			//_Seed ("Seed", Float) = 31337.1337
float _Persistence;		//_Persistence ("NoisePersistence", Range(0, 1)) = .95
float _Scale;			//_Scale ("NoiseScale", Float) = 20.0

int octaves;			//Number of 'octaves' for perlin noise
float seed;				//'seed' value for generation of randomness.
float persistence;		//
float scale;			//


///Resets the octaves, seed, persistence and scale to the 'hooked' values
///(_Octaves, _Seed, _Persistence, _Scale)
///Typically, this function should be called once at the begining of procedural texture code.
inline void resetNoise() { 
	octaves = _Octaves;
	seed = _Seed;
	persistence = _Persistence;
	scale = _Scale;
}

// #define resetNoise() \
//	octaves = _Octaves; seed = _Seed; persistence = _Persistence; scale = _Scale;

///Sets the values for noise
///Order of parameters is 
///seed, scale, persistence, octaves
///if parameters are ommitted, they are not changed.
inline void setNoise(float sd) { seed = sd; }
inline void setNoise(float sd, float sc) { seed = sd; scale = sc; }
inline void setNoise(float sd, float sc, float per) { seed = sd; scale = sc; persistence = per; }
inline void setNoise(float sd, float sc, float per, int oc) { 
	seed = sd; 
	scale = sc; 
	persistence = per; 
	octaves = oc;
}
///Quick hash method
inline float hash(float n) { return frac(sin(n)*seed); }
///Quick 3d version of hash
inline float hash3(float3 v) {
	return hash(v.x + v.y*157.0 + 113.0*v.z);
}
//Quick smoothing
inline float2 smooth(float2 uv) { return uv*uv*(3.-2.*uv); }

///Quick (no smoothing) 1d noise
inline float qnoise1(float x) {
	const float p = floor(x);
	const float f = frac(x);
	return lerp(hash(p+0.0), hash(p+1.0), f);
}

///Smooth 1d noise
inline float noise1(float x) {
	const float p = floor(x);
	const float f = frac(x);
	const float f2= f*f*(3.0-2.0*f);
	return lerp(hash(p+0.0), hash(p+1.0), f2);
}

///Smooth, standard 3d FBM like noise.
inline float noise(float3 x) {
	const float3 p = floor(x);
	const float3 f = frac(x);
	const float3 f2= f*f*(3.0-2.0*f);
	const float n = p.x + p.y*157.0 + 113.0*p.z;

	return lerp(lerp(	lerp( hash(n+0.0), hash(n+1.0),f2.x),
						lerp( hash(n+157.0), hash(n+158.0),f2.x),f2.y),
				lerp(	lerp( hash(n+113.0), hash(n+114.0),f2.x),
						lerp( hash(n+270.0), hash(n+271.0),f2.x),f2.y),f2.z);
}
#endif