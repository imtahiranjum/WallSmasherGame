/*
// Procedural Surface Shaders
// Jonathan Cohen / ninjapretzel
// 2016-2017
// Fractal Brownian Motion

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
//	(onoise) octave noise
//	(nnoise) normalized octave noise


#ifndef FBM_INCLUDED
#define FBM_INCLUDED


///Octave-3d noise  function
///Output is in range [0...1], but, clusters mostly between .4 and .6
///Use nnoise for values that take up the whole range.
float onoise(float3 pos) {
	float total = 0.0
		, frequency = scale
		, amplitude = 1.0
		, maxAmplitude = 0.0;
	
	for (int i = 0; i < octaves; i++) {
		total += noise(pos * frequency) * amplitude;
		frequency *= 2.0, maxAmplitude += amplitude;
		amplitude *= persistence;
		// No reason to not ever do this
		// Swizle to spread degredation across all axis.
		pos = pos.yzx; 
	}
	
	
	return total / maxAmplitude;
}



///normalized octave noise function, output is in range [0...1]
///factor parameter controls how 'tight' the noise is.
///Default is (factor = 0.5)
float nnoise(float3 pos, float factor) {
	float total = 0.0
		, frequency = scale
		, amplitude = 1.0
		, maxAmplitude = 0.0;
	
	for (int i = 0; i < octaves; i++) {
		total += noise(pos * frequency) * amplitude;
		frequency *= 2.0, maxAmplitude += amplitude;
		amplitude *= persistence;
		// No reason to not ever do this.
		// Swizle to spread degredation across all axis.
		pos = pos.yzx; 
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
///Default factor = 0.5
float nnoise(float3 pos) { return nnoise(pos, 0.5); }

#endif