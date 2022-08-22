/*
// Procedural Surface Shaders
// Jonathan Cohen / ninjapretzel
// 2016-2017
// Lumpy

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

Shader "ProcSurface/Lumpy" {
	Properties {
		[Header(Variant Toggles)]
		[Toggle(WORLEY)] _WORLEY("Use Worley Noise", Float) = 1
		[Toggle(WORLDSPACE)] _WORLDSPACE("Use Worldspace position", Float) = 1
		[Toggle(FANCY_PARALLAX)] _FANCY_PARALLAX("Fancy Parallax", Float) = 1
		
		[Header(Colors)]
		_Color1 ("Primary Color", Color) = (1.,.8588,.8588,1)
		_Color2 ("Secondary Color", Color) = (.1255,.098,.0314,1)
		
		[Header(Surface Property)]
		_Polish ("Polish", Range(0,4)) = 0
		_Glossiness ("Smoothness", Range(0,1)) = 0.211
		_Metallic ("Metallic", Range(0,1)) = 0.0
		
		[Header(Lumpyness)]
		_VoroComp ("Voroni Composition", Vector) = (-1, 1, .3, 1)
		_VoroScale ("Voroni Scale", Float) = 7.01
		
		[Header(Bump Texture)]
		_BumpOctaves ("Bump Octaves", Range(1, 8)) = 5.0
		_BumpPersistence ("Bump Persistence", Range(0, 1)) = .509
		_BumpScale ("Bump Spread", Float) = 14
		_BumpAmt ("Bump Amount", Range(.01, 2)) = 2.46
		
		[Header(Noise Settings)]
		_Seed ("Seed", Float) = 16567
		_Octaves ("Octaves", Range(1, 32)) = 3.0
		_Persistence ("Persistence", Range(0, 1)) = .482
		_Scale ("Scale", Float) = 1
		
		
		[Header(Parallax Settings)]
		_Parallax ("Parallax Amount", Float) = 111
		// Depth Layers for Fancy parallax
		_DepthLayers ("Depth Layers", Range(8, 32)) = 8
		
		
		[Header(Texture Offsets)]
		_Offset ("Noise Offset (x,y,z) * w", Vector) = (0, 0, 0, 1)
	}
	SubShader {
		Tags { 
			"RenderType"="Opaque" 
			// Prevents objects from being batched:
			"DisableBatching"="True" 
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard vertex:vert_add_wNormal fullforwardshadows 
		#pragma target 3.0
		#pragma multi_compile __ WORLEY
		#pragma multi_compile __ WORLDSPACE
		#pragma multi_compile __ FANCY_PARALLAX
		
		#include "inc/procheight.cginc"
		#include "inc/noiseprims.cginc"
		#include "inc/fbm.cginc"
		#include "inc/voroni.cginc"
		#include "inc/fbmNormal.cginc"
		
		float _VoroScale;
		float _Polish;
		half _Glossiness;
		half _Metallic;
		fixed4 _Color1;
		fixed4 _Color2;
		
		float _Factor;
		float4 _VoroComp;
		float4 _Offset;
		
		inline float voro(float3 pos) {
			return voroni(pos, float3(1,1,1), _VoroComp, 
			#ifdef WORLEY
				VORONI_NORMAL
			#else
				VORONI_MANHATTAN
			#endif
			);
					
		}
		
		inline half Depth3D(float3 pos) {
			return 1.0 - voro(pos * _VoroScale);
		}
			
		
		void surf(Input IN, inout SurfaceOutputStandard o) {
			resetNoise();
			float4 wpos = float4(IN.worldPos, 1);
			#ifdef WORLDSPACE
				float3 pos = wpos;
			#else 
				float3 pos = mul(unity_WorldToObject, wpos);
			#endif
			pos += + _Offset.xyz * _Offset.w;
			//scale = _VoroScale;
			
			#ifdef FANCY_PARALLAX
				pos = Parallax3D_Occ(IN, pos);
			#else
				const float h = Depth3D(pos);
				float3 offset = parallax3d(IN, h);
				pos += offset;
			#endif
			
			
			
			const float v0 = voro(pos * _VoroScale);
			const float v1 = nnoise(pos);
							
			
			o.Albedo = saturate(v0)* _Color1 + v1 * _Color2;
			o.Normal = fbmNormal(pos);
			
			//o.Emission = clamp(2 * abs(IN.wNormal), 0., 1.);
			const float gloss = v0 * _Polish;
			const float antiGloss = (1.0-v0) * saturate(1.0-_Polish);
			
			o.Metallic = _Metallic * gloss + _Metallic * antiGloss;
			o.Smoothness = _Glossiness * gloss + _Glossiness * antiGloss;
			o.Alpha = 1;
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}
