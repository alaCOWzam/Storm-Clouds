// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Honey-Yam/Scrolling Texture"
{
	Properties
	{
		[HDR]_Colour("Colour", Color) = (1,1,1,1)
		_Texture("Texture", 2D) = "white" {}
		_TextureScroll("Texture Scroll", Vector) = (0,0,0,0)
		_TextureRemapMin("Texture Remap Min", Range( 0 , 1)) = 0
		_TextureRemapMax("Texture Remap Max", Range( 0 , 1)) = 1
		_TexturePower("Texture Power", Float) = 1
		_Noise("Noise", 2D) = "white" {}
		_NoiseMaskTiling("Noise Mask Tiling", Vector) = (1,1,0,0)
		_NoiseMaskScrolling("Noise Mask Scrolling", Vector) = (0,0,0,0)
		_NoiseMaskRemapMin("Noise Mask Remap Min", Range( 0 , 1)) = 0
		_NoiseMaskRemapMax("Noise Mask Remap Max", Range( 0 , 1)) = 1
		_NoiseMaskPower("Noise Mask Power", Float) = 1
		_DistortNoise("Distort Noise", Range( 0 , 1)) = 0
		_DistortNoiseTiling("Distort Noise Tiling", Vector) = (1,1,0,0)
		_DistortNoiseScrolling("Distort Noise Scrolling", Vector) = (0,0,0,0)
		_DistortNoiseRemapMin("Distort Noise Remap Min", Range( 0 , 1)) = 0
		_DistortNoiseRemapMax("Distort Noise Remap Max", Range( 0 , 1)) = 1
		_DistortNoisePower("Distort Noise Power", Float) = 1
		_RadialMaskRemapMin("Radial Mask Remap Min", Range( 0 , 1)) = 0
		_RadialMaskRemapMax("Radial Mask Remap Max", Range( 0 , 1)) = 1
		_RadialMaskPower("Radial Mask Power", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Colour;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float2 _DistortNoiseTiling;
		uniform float2 _DistortNoiseScrolling;
		uniform float _DistortNoiseRemapMin;
		uniform float _DistortNoiseRemapMax;
		uniform float _DistortNoisePower;
		uniform float _DistortNoise;
		uniform float2 _TextureScroll;
		uniform float _TextureRemapMin;
		uniform float _TextureRemapMax;
		uniform float _TexturePower;
		uniform float _RadialMaskRemapMin;
		uniform float _RadialMaskRemapMax;
		uniform float _RadialMaskPower;
		uniform float2 _NoiseMaskTiling;
		uniform float2 _NoiseMaskScrolling;
		uniform float _NoiseMaskRemapMin;
		uniform float _NoiseMaskRemapMax;
		uniform float _NoiseMaskPower;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float temp_output_1_0_g5 = _DistortNoiseRemapMin;
			float DistortNoise80 = ( pow( saturate( ( ( tex2D( _Noise, ( ( uv_Noise * _DistortNoiseTiling ) + ( _DistortNoiseScrolling * _Time.y ) ) ).r - temp_output_1_0_g5 ) / ( _DistortNoiseRemapMax - temp_output_1_0_g5 ) ) ) , _DistortNoisePower ) * _DistortNoise );
			float2 TextureUV7 = ( ( uv_Texture + DistortNoise80 ) + ( _TextureScroll * _Time.y ) );
			float4 tex2DNode12 = tex2D( _Texture, TextureUV7 );
			float temp_output_1_0_g8 = _TextureRemapMin;
			float Texture18 = pow( saturate( ( ( tex2DNode12.r - temp_output_1_0_g8 ) / ( _TextureRemapMax - temp_output_1_0_g8 ) ) ) , _TexturePower );
			float2 uv_TexCoord6 = i.uv_texcoord * float2( 2,2 ) + float2( -1,-1 );
			float temp_output_1_0_g7 = _RadialMaskRemapMin;
			float RadialMask17 = pow( saturate( ( ( ( 1.0 - length( uv_TexCoord6 ) ) - temp_output_1_0_g7 ) / ( _RadialMaskRemapMax - temp_output_1_0_g7 ) ) ) , _RadialMaskPower );
			float temp_output_1_0_g6 = _NoiseMaskRemapMin;
			float NoiseMask42 = pow( saturate( ( ( tex2D( _Noise, ( ( uv_Noise * _NoiseMaskTiling ) + ( _NoiseMaskScrolling * _Time.y ) ) ).r - temp_output_1_0_g6 ) / ( _NoiseMaskRemapMax - temp_output_1_0_g6 ) ) ) , _NoiseMaskPower );
			float4 Colour23 = ( _Colour * Texture18 * RadialMask17 * NoiseMask42 );
			o.Emission = Colour23.rgb;
			o.Alpha = Colour23.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18933
0;619.3334;1277.667;739.6667;893.6721;178.9221;1;False;False
Node;AmplifyShaderEditor.Vector2Node;65;-5113.238,2960.422;Inherit;False;Property;_DistortNoiseTiling;Distort Noise Tiling;13;0;Create;True;0;0;0;False;0;False;1,1;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;66;-5104.783,3131.063;Inherit;False;Property;_DistortNoiseScrolling;Distort Noise Scrolling;14;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;31;-4313.148,1162.182;Inherit;True;Property;_Noise;Noise;6;0;Create;True;0;0;0;False;0;False;None;cbfa418e913a0f540ad0bca3afee56c6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleTimeNode;67;-5049.183,3327.546;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-5118.173,2791.702;Inherit;False;0;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-3963.403,1163.62;Inherit;False;Noise;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-4612.835,2923.185;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-4573.558,3090.551;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-4241.928,2960.002;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-4521.664,2807.484;Inherit;False;32;Noise;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-3861.372,2735.057;Inherit;False;Property;_DistortNoiseRemapMax;Distort Noise Remap Max;16;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;-3893.238,2929.703;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;-3870.436,2599.051;Inherit;False;Property;_DistortNoiseRemapMin;Distort Noise Remap Min;15;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;76;-3312.626,2833.216;Inherit;False;Inverse Lerp;-1;;5;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;77;-2986.463,2743.651;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-3337.055,3008.287;Inherit;False;Property;_DistortNoisePower;Distort Noise Power;17;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;79;-2704.984,2831.139;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-2903.752,3048.776;Inherit;False;Property;_DistortNoise;Distort Noise;12;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-2421.131,2844.97;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;-2149.694,2832.105;Inherit;False;DistortNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-4236.992,-593.9462;Inherit;False;80;DistortNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-4252.646,-756.5496;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2;-4150.875,-226.2953;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1;-4206.979,-426.4673;Inherit;False;Property;_TextureScroll;Texture Scroll;2;0;Create;True;0;0;0;False;0;False;0,0;0.04,0.04;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-3806.411,-385.0564;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-3831.992,-603.9462;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-3498.911,-479.5677;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;39;-5191.133,2104.057;Inherit;False;Property;_NoiseMaskScrolling;Noise Mask Scrolling;8;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;40;-5135.533,2300.539;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-5204.523,1764.695;Inherit;False;0;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;38;-5199.588,1933.415;Inherit;False;Property;_NoiseMaskTiling;Noise Mask Tiling;7;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-4659.908,2063.544;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-4699.185,1896.178;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-3274.101,-487.0578;Inherit;False;TextureUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2755.945,-350.6526;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;-1,-1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;8;-2410.875,-354.1846;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-4608.014,1780.477;Inherit;False;32;Noise;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-4801.62,640.6835;Inherit;False;7;TextureUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-4328.279,1932.996;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-3947.723,1708.05;Inherit;False;Property;_NoiseMaskRemapMax;Noise Mask Remap Max;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-4444.677,253.3262;Inherit;False;Property;_TextureRemapMin;Texture Remap Min;3;0;Create;True;0;0;0;False;0;False;0;0.181;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2117.7,-638.0289;Inherit;False;Property;_RadialMaskRemapMin;Radial Mask Remap Min;18;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-3979.589,1902.696;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-4443.598,412.2392;Inherit;False;Property;_TextureRemapMax;Texture Remap Max;4;0;Create;True;0;0;0;False;0;False;1;0.771;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-3954.821,1572.044;Inherit;False;Property;_NoiseMaskRemapMin;Noise Mask Remap Min;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2165.823,-501.4648;Inherit;False;Property;_RadialMaskRemapMax;Radial Mask Remap Max;19;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-4490.966,567.7186;Inherit;True;Property;_Texture;Texture;1;0;Create;True;0;0;0;False;0;False;-1;None;ef39d90d98c4fca40a59bf4b42ae3173;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;10;-2057.549,-354.6476;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;27;-3896.714,456.8791;Inherit;False;Inverse Lerp;-1;;8;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;43;-3398.977,1806.209;Inherit;False;Inverse Lerp;-1;;6;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;51;-1624.495,-413.0271;Inherit;False;Inverse Lerp;-1;;7;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-3423.406,1981.28;Inherit;False;Property;_NoiseMaskPower;Noise Mask Power;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;-3072.814,1716.644;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1976.528,-40.12548;Inherit;False;Property;_RadialMaskPower;Radial Mask Power;20;0;Create;True;0;0;0;False;0;False;1;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;13;-1308.035,-368.5667;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;30;-3610.497,447.6482;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3666.31,645.5859;Inherit;False;Property;_TexturePower;Texture Power;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-3283.027,521.3536;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;-2791.335,1804.132;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;16;-1050.216,-268.0934;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-785.4365,-254.9116;Inherit;False;RadialMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-3021.727,505.5635;Inherit;False;Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-2428.1,1825.74;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2093.833,668.2228;Inherit;False;42;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2164.444,437.089;Inherit;False;18;Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-2146.362,209.9421;Inherit;False;Property;_Colour;Colour;0;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;2,2,2,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;21;-2144.433,556.619;Inherit;False;17;RadialMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1703.59,406.3521;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1433.258,401.4259;Inherit;False;Colour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-559.4475,198.4178;Inherit;False;23;Colour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;86;-4165.415,677.5148;Inherit;False;FLOAT3;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-4272.161,894.7651;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;26;-221.7166,197.1153;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;25;-492.0614,-46.81261;Inherit;False;23;Colour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-4268.161,796.7651;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;54;-3966.474,612.5125;Inherit;True;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;55.09112,-6.121236;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Scrolling Texture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;31;0
WireConnection;70;0;68;0
WireConnection;70;1;65;0
WireConnection;69;0;66;0
WireConnection;69;1;67;0
WireConnection;72;0;70;0
WireConnection;72;1;69;0
WireConnection;74;0;71;0
WireConnection;74;1;72;0
WireConnection;76;1;73;0
WireConnection;76;2;75;0
WireConnection;76;3;74;1
WireConnection;77;0;76;0
WireConnection;79;0;77;0
WireConnection;79;1;78;0
WireConnection;81;0;79;0
WireConnection;81;1;82;0
WireConnection;80;0;81;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;83;0;4;0
WireConnection;83;1;84;0
WireConnection;5;0;83;0
WireConnection;5;1;3;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;37;0;35;0
WireConnection;37;1;38;0
WireConnection;7;0;5;0
WireConnection;8;0;6;0
WireConnection;36;0;37;0
WireConnection;36;1;41;0
WireConnection;34;0;33;0
WireConnection;34;1;36;0
WireConnection;12;1;9;0
WireConnection;10;0;8;0
WireConnection;27;1;28;0
WireConnection;27;2;29;0
WireConnection;27;3;12;1
WireConnection;43;1;44;0
WireConnection;43;2;45;0
WireConnection;43;3;34;1
WireConnection;51;1;52;0
WireConnection;51;2;53;0
WireConnection;51;3;10;0
WireConnection;46;0;43;0
WireConnection;13;0;51;0
WireConnection;30;0;27;0
WireConnection;15;0;30;0
WireConnection;15;1;11;0
WireConnection;47;0;46;0
WireConnection;47;1;48;0
WireConnection;16;0;13;0
WireConnection;16;1;14;0
WireConnection;17;0;16;0
WireConnection;18;0;15;0
WireConnection;42;0;47;0
WireConnection;22;0;19;0
WireConnection;22;1;64;0
WireConnection;22;2;21;0
WireConnection;22;3;49;0
WireConnection;23;0;22;0
WireConnection;86;0;12;0
WireConnection;26;0;24;0
WireConnection;54;0;86;0
WireConnection;54;1;28;0
WireConnection;54;2;29;0
WireConnection;54;3;60;0
WireConnection;54;4;61;0
WireConnection;0;2;25;0
WireConnection;0;9;26;3
ASEEND*/
//CHKSM=A6F24BFD2B6355C275357587D5D8DDD8AF4E113B