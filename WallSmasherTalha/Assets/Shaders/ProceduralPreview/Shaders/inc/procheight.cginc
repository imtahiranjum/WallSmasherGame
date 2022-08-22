/*
// Procedural Surface Shaders
// Jonathan Cohen / ninjapretzel
// 2016-2017
// Parallax

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
// Defines Input struct and vertex shader for adding TBN information
// As well as a few methods for parallax itself.

#ifndef PROC_HEIGHT
#define PROC_HEIGHT

/*
Recommended Properties block additions:
		// Multi-Compile for simple/complex parallax.
		[Toggle(FANCY_PARALLAX)] _FANCY_PARALLAX("Fancy Parallax", Float) = 0
		// Inside CGPROGRAM
		#pragma multi_compile __ FANCY_PARALLAX
		
		// Basic Settings 
		[Header(Parallax Settings)]
		_Parallax ("Parallax amount", Float) = 333
		
		// Depth Layers for Fancy parallax
		_DepthLayers ("Depth Layers", Range(8, 32)) = 8
		
		// Extra control, sometimes useful to reduce 'shimmering' or other werid artifacts on parallaxed surfaces.
		_Mush ("Parallax Tangent/Binormal/Normal 'Mushing'", Vector) = (1, 1, 0, 0)
	
//*/

// Definitions for variables inside of Properties block
float _Parallax;
int _DepthLayers;

//Has to be named 'Input', apparantly.
//Guess that makes this a bit boiler-platey.
//And also constrains what can be done when this file is included.
struct Input {
	float3 worldPos;
	float3 viewDir;
	float3 wNormal;
	float3 wTangent;
	float3 wBinormal;
};

// Prototype for depthfield function.
inline fixed Depth3D(float3 pos);

float4 mush;
int layers;

// Basic Layered Parallax Function
// Takes surface info and start position for raycast (intersection of surface)
// Returns result surface position based on where the raycast 'hits'
/* 
// Commented to speed up compile, rarely needs to be used
// Included just because it's a simpler version of parallax.
inline float3 Parallax3D_Layered(Input IN, float3 start) {
	if (length(mush) == 0) { mush = 1; }
	half3 blend = abs(IN.wNormal);
	//const float numLayers = lerp(8.0, _DepthLayers, abs(dot(float3(0,0,1), IN.viewDir)));
	const float layerDepth = 1.0 / _DepthLayers;
	
	const float3 p = -IN.viewDir * (.001 * _Parallax - _Bias * .001);
	const float3 delta = (_Mush.x p.x * IN.wTangent + _Mush.y * p.y * -IN.wBinormal + _Mush.z * p.z * IN.wNormal) / _DepthLayers;
	
	float3 pos = start;
	fixed curDepth = 0.0;
	fixed curTexDepth = Depth3D(pos);
	
	int iter = 0;
	layers = _DepthLayers;
	
	for (iter = 0; iter < layers; iter++) {
		if (curDepth < curTexDepth) { 
			pos += delta;
			curTexDepth = Depth3D(pos);
			curDepth += layerDepth;
		}
	}
		
	return pos;
}
*/



// Occulsion Layered Parallax Function
// Similar to Layered Parallax, but also has 
// Takes surface info and start position for raycast (intersection of surface)
// Returns result surface position based on where the raycast 'hits'
inline float3 Parallax3D_Occ(Input IN, float3 start) {
	if (length(mush) == 0) { mush = float4(1.0, 1.0, 0.0, 0.0); }
	const float layerDepth = 1.0 / _DepthLayers;
	
	const float3 p = -IN.viewDir * (.001 * _Parallax);
	const float3 delta = (mush.x * p.x * IN.wTangent + mush.y * p.y * -IN.wBinormal + mush.z * p.z * IN.wNormal) / (0.0+_DepthLayers);
	
	float3 pos = start;
	fixed curDepth = 0.0;
	fixed prevDepth = 0.0;
	fixed curTexDepth = Depth3D(pos);
	
	
	int iter;
	layers = _DepthLayers;
	for (iter = 0; iter < _DepthLayers; iter++) {
		if (curDepth < curTexDepth) {
			prevDepth = curTexDepth;
			pos += delta;
			curTexDepth = Depth3D(pos);
			curDepth += layerDepth;
		} else { break; }
	}
	
	float3 prev = pos - delta;
	fixed after = curTexDepth - curDepth;
	fixed before = prevDepth - curTexDepth + layerDepth;
	
	fixed weight = after / (after - before);
	
	return prev * weight + pos * (1.0 - weight);
}




// Simple, condensed parallax function, which only calculates a delta for one 'layer' parallax.
// Much faster than Occulsion Parallax, but less accurate.
inline float3 parallax3d(Input IN, float h) {
	if (length(mush) == 0) { mush = float4(1.0, 1.0, 0.0, 0.0); }
	
	float3 nrm = normalize(IN.wNormal);
	float hv = h * (_Parallax * .001);
	float3 eye = IN.viewDir;
	//float3 dir = eye - nrm * dot(eye, nrm) / dot(nrm, nrm);
	float3 r = -hv*(mush.x * eye.x * IN.wTangent - mush.y * eye.y * IN.wBinormal + mush.z * eye.z * IN.wNormal);//hv * -dir;
	return r;
}

//must use this tp=o init Input
//add vertex:vert_add_wnormal to surface pragma
void vert_add_wNormal(inout appdata_full v, out Input data) {
	#ifdef WORLDSPACE
	UNITY_INITIALIZE_OUTPUT(Input, data);
	data.worldPos = v.vertex.xyz;
	data.viewDir = WorldSpaceViewDir(v.vertex);
	
	float3x3 o2w = (float3x3)unity_ObjectToWorld;
	data.wNormal = normalize(mul(o2w, v.normal.xyz));
	data.wTangent = normalize(mul(o2w, v.tangent.xyz));
	data.wBinormal = cross(data.wNormal, data.wTangent);
	#else
	UNITY_INITIALIZE_OUTPUT(Input, data);
	data.worldPos = v.vertex.xyz;
	data.viewDir = WorldSpaceViewDir(v.vertex);
	
	data.wNormal = v.normal.xyz;
	data.wTangent = v.tangent.xyz;
	data.wBinormal = cross(data.wNormal, data.wTangent);
	
	#endif
}



#endif
