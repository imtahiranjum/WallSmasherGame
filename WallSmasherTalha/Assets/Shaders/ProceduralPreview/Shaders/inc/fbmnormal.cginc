/*
// Procedural Surface Shaders
// Jonathan Cohen / ninjapretzel
// 2016-2017
// Normal Generation

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

// Very simple method of adding bumpiness to procedural surfaces

#ifndef FBMNORMAL
#define FBMNORMAL

/*
Recommended Properties block additions adjust as necessary.
		_BumpOctaves ("Bump Octaves", Range(1, 8)) = 4.0
		_BumpScale ("Bump Spread", Float) = 13.37
		_BumpPersistence ("Bump Persistence", Range(0, 1)) = .65
		_BumpAmt ("Bump Amount", Range(.01, 2)) = 1
//*/

int _BumpOctaves;
float _BumpScale;
float _BumpAmt;
float _BumpPersistence;
	
fixed3 fbmNormal(float3 pos) {
	octaves = _BumpOctaves;
	scale = _BumpScale;
	persistence = _BumpPersistence;
	
	const float v1 = nnoise(pos);
	const float v2 = nnoise(pos * 1.5);
	
	const float a = -1 + 2 * v1;
	const float b = -1 + 2 * v2;
	
	const fixed3 n = fixed3(a * _BumpAmt, b * _BumpAmt, 3);
	
	return normalize(n);
}

#endif