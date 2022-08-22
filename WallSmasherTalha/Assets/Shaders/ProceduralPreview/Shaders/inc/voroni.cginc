/*
// Procedural Surface Shaders
// Jonathan Cohen / ninjapretzel
// 2016-2017
// Voroni Noise

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
//Requires noiseprims.cginc

//This file defines:
//	voroni2 (2d voroni prim)
//	voroni3 (3d voroni prim)
//	ovoroni3 (3d voroni octave noise)
//	nvoroni3 (3d voroni normalized octave noise)

#ifndef VORONI_INCLUDED
#define VORONI_INCLUDED

#define VORONI_FROM -1
#define VORONI_TO 2

#define VORONI_MANHATTAN 0
#define VORONI_NORMAL 1

inline float voroni(float3 v, float3 shift, float4 comp, int distMode) {
	//Integer and fractional components
	const float3 p = floor(v);
	const float3 f = frac(v);
	
	//Tracking closest point distances.
	float3 closest = float3(1.0, 1.0, 1.0);
	
	//Loop over 4x4x4 local neighborhood
	for (int k = VORONI_FROM; k <= VORONI_TO; k++) {
		for (int j = VORONI_FROM; j <= VORONI_TO; j++) {
			for (int i = VORONI_FROM; i <= VORONI_TO; i++) {
				
				const float3 sampleOffset = float3(i, j, k);
				float3 featurePoint = sampleOffset - f + shift * (hash3(p + sampleOffset));
				
				float dist = 0.0;
				//Different distance modes can be accessed through multicompile.
				
				if (distMode == VORONI_MANHATTAN) {
					//Uses Checkshev distance
					featurePoint = abs(featurePoint);
					dist = max(max(featurePoint.x, featurePoint.y), featurePoint.z);
				} else {  
					//Normal distance
					dist = length(featurePoint);
				}
				
				//Properly track the closest 3 point distances
				if (dist < closest[0]) { closest[2] = closest[1]; closest[1] = closest[0]; closest[0] = dist; }
				else if (dist < closest[1]) { closest[2] = closest[1]; closest[1] = dist; }
				else if (dist < closest[2]) { closest[2] = dist; }
			}
		}
	}
	
	//Combine 3 distances based on 'comp' parameter
	return comp.w * abs(comp.x * closest.x + comp.y * closest.y + comp.z * closest.z);
}


inline float voroniSep(float3 v, float3 shift, float4 comp, int distMode) {
	//Integer and fractional components
	const float3 p = floor(v);
	const float3 f = frac(v);
	
	//Tracking closest point distances.
	float3 closest = float3(1.0, 1.0, 1.0);
	
	//Loop over 4x4x4 local neighborhood
	for (int k = VORONI_FROM; k <= VORONI_TO; k++) {
		for (int j = VORONI_FROM; j <= VORONI_TO; j++) {
			for (int i = VORONI_FROM; i <= VORONI_TO; i++) {
				
				const float3 sampleOffset = float3(i, j, k);
				const float3 samp = p + sampleOffset;
				const float3 sh = shift * float3(hash3(samp), hash3(samp * 1.33), hash3(samp * .76));
				
				float3 featurePoint = sampleOffset - f + sh;
				
				float dist = 0.0;
				//Different distance modes can be accessed through multicompile.
				
				if (distMode == VORONI_MANHATTAN) {
					//Uses Checkshev distance
					featurePoint = abs(featurePoint);
					dist = max(max(featurePoint.x, featurePoint.y), featurePoint.z);
				} else {  
					//Normal distance
					dist = length(featurePoint);
				}
				
				//Properly track the closest 3 point distances
				if (dist < closest[0]) { closest[2] = closest[1]; closest[1] = closest[0]; closest[0] = dist; }
				else if (dist < closest[1]) { closest[2] = closest[1]; closest[1] = dist; }
				else if (dist < closest[2]) { closest[2] = dist; }
			}
		}
	}
	
	//Combine 3 distances based on 'comp' parameter
	return comp.w * abs(comp.x * closest.x + comp.y * closest.y + comp.z * closest.z);
}


inline float manhattan(float3 v) { return voroni(v, float3(1,1,1), float4(-1,1,.30,1.), VORONI_MANHATTAN); }
inline float manhattan3(float3 v) { return voroni(v, float3(1,1,1), float4(-1,.5,.5,1.7), VORONI_MANHATTAN); }
inline float voroni1f(float3 v) { return voroni(v, float3(1,1,1), float4(1,0,0,.8), VORONI_NORMAL); }
inline float voroni2f(float3 v) { return voroni(v, float3(1,1,1), float4(0,1,0,.8), VORONI_NORMAL); }
inline float worley(float3 v) { return voroni(v, float3(1,1,1), float4(-1,1,0,1.0), VORONI_NORMAL); }

///2d voronoi manhattan distance noise
inline float voroni2(float2 x) {
	const float2 p = floor(x);
	const float2 f = frac(x);
	
	float2 res = float2(1.0, 1.0);
	for (int j = VORONI_FROM; j <= VORONI_TO; j ++) {
		for (int i = VORONI_FROM; i <= VORONI_TO; i ++) {
			const float2 b = float2(i, j);
			const float2 r = float2(b) - f + hash3(float3(p + b, 0.0));
			
			const float d = max(abs(r.x), abs(r.y));
			
			if(d < res.x) 		{ 	res.y = res.x;	res.x = d; }
			else if(d < res.y) 	{	res.y = d; 	}
		}
	}
	return res.y - res.x;
}



///3d voronoi manhattan distance noise
inline float voroni3(float3 x) {
	const float3 p = floor(x);
	const float3 f = frac(x);
	
	float3 res = float3(1.0, 1.0, 1.0);
	for (int k = VORONI_FROM; k <= VORONI_TO; k++) {
		for (int j = VORONI_FROM; j <= VORONI_TO; j++) {
			for (int i = VORONI_FROM; i <= VORONI_TO; i++) {
				const float3 b = float3(i, j, k);
				const float3 r = b - f + hash3(p + b);
				
				const float d = max(max(abs(r.x), abs(r.y)), abs(r.z));
				if (d < res.x) {
					res.z = res.y;
					res.y = res.x;
					res.x = d;
				} else if (d < res.y) {
					res.z = res.y;
					res.y = d;
				} else if (d < res.z) {
					res.z = d;
				}
			}
		}
	}
	return res.y - res.x;
}


float ovoroni3(float3 p) {
    float total = 0.0
		, frequency = scale
		, amplitude = 1.0
		, maxAmplitude = 0;
		
    for(int i = 0; i < octaves; i++) {
        total += amplitude * voroni3(p * frequency);
        frequency *= 2.0, maxAmplitude += amplitude;
        amplitude *= persistence;
		// Swizle to spread degredation across all axis
		// Rather than letting it bunch up on y/z
		p = p.yzx;
    }
    return total / maxAmplitude;
}

float nvoroni3(float3 p, float factor) {
    float total = 0.0
		, frequency = scale
		, amplitude = 1.0
		, maxAmplitude = 0;
		
    for(int i = 0; i < octaves; i++) {
        total += amplitude * voroni3(p * frequency);
        frequency *= 2.0, maxAmplitude += amplitude;
        amplitude *= persistence;
		// Swizle to spread degredation across all axis
		// Rather than letting it bunch up on y/z
		p = p.yzx; 
    }
	
	float avg = maxAmplitude * .5;
	if (factor != 0) {
		float range = avg * clamp(factor, 0, 1);
		float mmin = avg - range;
		float mmax = avg + range;
		
		float val = clamp(total, mmin, mmax);
		return val = (val - mmin) / (mmax - mmin);
	} 
	
	if (total > avg) { return 1; }
	return 0;
}
float nvoroni3(float3 pos) { return nvoroni3(pos, 0.5); }




#endif