// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Honey-Yam/Scrolling Textures"
{
	Properties
	{
		_Colour("Colour", Color) = (1,1,1,1)
		[Toggle(_SUBTRACTIVETEXTUREBLENDING_ON)] _SubtractiveTextureBlending("Subtractive Texture Blending", Float) = 0
		_TextureA("Texture A", 2D) = "white" {}
		_TextureARemapMin("Texture A - Remap Min", Range( 0 , 1)) = 0
		_TextureARemapMax("Texture A - Remap Max", Range( 0 , 1)) = 1
		_TextureAPower("Texture A - Power", Float) = 1
		_TextureAScroll("Texture A - Scroll", Vector) = (0,0,0,0)
		_TextureB("Texture B", 2D) = "white" {}
		_TextureBRemapMin("Texture B - Remap Min", Range( 0 , 1)) = 0
		_TextureBRemapMax("Texture B - Remap Max", Range( 0 , 1)) = 1
		_TextureBPower("Texture B - Power", Float) = 1
		_TextureBScroll("Texture B - Scroll", Vector) = (0,0,0,0)
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
		#pragma shader_feature_local _SUBTRACTIVETEXTUREBLENDING_ON
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureA;
		uniform float4 _TextureA_ST;
		uniform float2 _TextureAScroll;
		uniform float _TextureARemapMin;
		uniform float _TextureARemapMax;
		uniform float _TextureAPower;
		uniform sampler2D _TextureB;
		uniform float4 _TextureB_ST;
		uniform float2 _TextureBScroll;
		uniform float _TextureBRemapMin;
		uniform float _TextureBRemapMax;
		uniform float _TextureBPower;
		uniform float _RadialMaskRemapMin;
		uniform float _RadialMaskRemapMax;
		uniform float _RadialMaskPower;
		uniform float4 _Colour;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureA = i.uv_texcoord * _TextureA_ST.xy + _TextureA_ST.zw;
			float temp_output_1_0_g2 = _TextureARemapMin;
			float TextureA18 = pow( saturate( ( ( tex2D( _TextureA, ( uv_TextureA + ( _TextureAScroll * _Time.y ) ) ).r - temp_output_1_0_g2 ) / ( _TextureARemapMax - temp_output_1_0_g2 ) ) ) , _TextureAPower );
			float2 uv_TextureB = i.uv_texcoord * _TextureB_ST.xy + _TextureB_ST.zw;
			float temp_output_1_0_g3 = _TextureBRemapMin;
			float TextureB19 = pow( saturate( ( ( tex2D( _TextureB, ( uv_TextureB + ( _TextureBScroll * _Time.y ) ) ).r - temp_output_1_0_g3 ) / ( _TextureBRemapMax - temp_output_1_0_g3 ) ) ) , _TextureBPower );
			float TextureAMultB55 = ( TextureA18 * TextureB19 );
			float TextureAMinusB50 = saturate( ( TextureA18 - TextureB19 ) );
			#ifdef _SUBTRACTIVETEXTUREBLENDING_ON
				float staticSwitch59 = TextureAMinusB50;
			#else
				float staticSwitch59 = TextureAMultB55;
			#endif
			float2 uv_TexCoord30 = i.uv_texcoord * float2( 2,2 ) + float2( -1,-1 );
			float temp_output_1_0_g4 = _RadialMaskRemapMin;
			float RadialMask33 = pow( saturate( ( ( saturate( ( 1.0 - length( uv_TexCoord30 ) ) ) - temp_output_1_0_g4 ) / ( _RadialMaskRemapMax - temp_output_1_0_g4 ) ) ) , _RadialMaskPower );
			float4 Colour63 = ( staticSwitch59 * RadialMask33 * _Colour );
			o.Emission = Colour63.rgb;
			o.Alpha = Colour63.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
0;617.3334;1280.333;741.6667;6244.48;1768.531;4.427182;True;False
Node;AmplifyShaderEditor.Vector2Node;17;-4326.335,84.09255;Inherit;False;Property;_TextureBScroll;Texture B - Scroll;11;0;Create;True;0;0;0;False;0;False;0,0;0.02,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;16;-4342.655,238.5118;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-3931.234,-703.2864;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-3935,-851.4283;Inherit;False;Property;_TextureAScroll;Texture A - Scroll;6;0;Create;True;0;0;0;False;0;False;0,0;0.01,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-3955.98,112.9677;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-4097.363,-76.31519;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-3631.019,-846.4067;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-3716.459,-1009.037;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-3407.716,-940.5647;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-3716.294,23.1185;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-3208.215,-950.3325;Inherit;True;Property;_TextureA;Texture A;2;0;Create;True;0;0;0;False;0;False;-1;None;ef39d90d98c4fca40a59bf4b42ae3173;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-3494.354,-262.5276;Inherit;False;Property;_TextureBRemapMin;Texture B - Remap Min;8;0;Create;True;0;0;0;False;0;False;0;0.03;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-3278.227,-1107.445;Inherit;False;Property;_TextureARemapMax;Texture A - Remap Max;4;0;Create;True;0;0;0;False;0;False;1;0.433;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3483.313,14.84409;Inherit;True;Property;_TextureB;Texture B;7;0;Create;True;0;0;0;False;0;False;-1;None;9847ae262cb15ac4a8b904e53471fcea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-3475.16,-120.0324;Inherit;False;Property;_TextureBRemapMax;Texture B - Remap Max;9;0;Create;True;0;0;0;False;0;False;1;0.519;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-3281.639,-1291.893;Inherit;False;Property;_TextureARemapMin;Texture A - Remap Min;3;0;Create;True;0;0;0;False;0;False;0;0.053;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;22;-3042.682,-129.3937;Inherit;False;Inverse Lerp;-1;;3;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;25;-2744.642,-1068.041;Inherit;False;Inverse Lerp;-1;;2;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-4002.661,743.1225;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;-1,-1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-2906.448,-678.9972;Inherit;False;Property;_TextureAPower;Texture A - Power;5;0;Create;True;0;0;0;False;0;False;1;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-2501.799,-997.8345;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;29;-2795.344,0.9533076;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3150.841,227.7032;Inherit;False;Property;_TextureBPower;Texture B - Power;10;0;Create;True;0;0;0;False;0;False;1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;4;-2307.835,-865.3372;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;31;-3634.376,736.1332;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;5;-2475.396,98.10656;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-2182.465,117.1201;Inherit;False;TextureB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-3348.455,772.9438;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-2021.575,-861.123;Inherit;False;TextureA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-1117.611,-644.1772;Inherit;False;19;TextureB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-3140.459,528.9776;Inherit;False;Property;_RadialMaskRemapMin;Radial Mask Remap Min;12;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;34;-3030.522,820.7631;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-3119.574,663.8111;Inherit;False;Property;_RadialMaskRemapMax;Radial Mask Remap Max;13;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1110.431,-779.3513;Inherit;False;18;TextureA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;36;-2666.292,647.106;Inherit;False;Inverse Lerp;-1;;4;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1122.95,-487.9321;Inherit;False;18;TextureA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1121.031,-355.3579;Inherit;False;19;TextureB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-875.6013,-710.7694;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-2421.977,645.7178;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;49;-696.4136,-711.817;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-754.8224,-443.541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2623.959,808.9609;Inherit;False;Property;_RadialMaskPower;Radial Mask Power;14;0;Create;True;0;0;0;False;0;False;1;1.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-504.169,-715.6164;Inherit;False;TextureAMinusB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-487.8469,-449.9251;Inherit;False;TextureAMultB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;42;-2218.959,667.9948;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1196.139,12.40256;Inherit;False;55;TextureAMultB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1945.045,638.7384;Inherit;False;RadialMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-1198.737,106.5365;Inherit;False;50;TextureAMinusB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;-1091.915,381.9705;Inherit;False;Property;_Colour;Colour;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.9641276,0.9308176,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1048.041,251.4354;Inherit;False;33;RadialMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;59;-911.3636,76.60448;Inherit;False;Property;_SubtractiveTextureBlending;Subtractive Texture Blending;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-466.973,193.9235;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-212.4769,173.7969;Inherit;False;Colour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;450.7538,-289.0837;Inherit;False;63;Colour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;642.7538,-440.0837;Inherit;False;63;Colour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;45;694.1352,-288.3657;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;932.0369,-470.0082;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Scrolling Textures;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;17;0
WireConnection;15;1;16;0
WireConnection;12;0;13;0
WireConnection;12;1;14;0
WireConnection;11;0;8;0
WireConnection;11;1;12;0
WireConnection;10;0;9;0
WireConnection;10;1;15;0
WireConnection;1;1;11;0
WireConnection;2;1;10;0
WireConnection;22;1;23;0
WireConnection;22;2;24;0
WireConnection;22;3;2;1
WireConnection;25;1;27;0
WireConnection;25;2;26;0
WireConnection;25;3;1;1
WireConnection;28;0;25;0
WireConnection;29;0;22;0
WireConnection;4;0;28;0
WireConnection;4;1;6;0
WireConnection;31;0;30;0
WireConnection;5;0;29;0
WireConnection;5;1;7;0
WireConnection;19;0;5;0
WireConnection;32;0;31;0
WireConnection;18;0;4;0
WireConnection;34;0;32;0
WireConnection;36;1;37;0
WireConnection;36;2;38;0
WireConnection;36;3;34;0
WireConnection;48;0;20;0
WireConnection;48;1;21;0
WireConnection;39;0;36;0
WireConnection;49;0;48;0
WireConnection;57;0;51;0
WireConnection;57;1;53;0
WireConnection;50;0;49;0
WireConnection;55;0;57;0
WireConnection;42;0;39;0
WireConnection;42;1;41;0
WireConnection;33;0;42;0
WireConnection;59;1;60;0
WireConnection;59;0;58;0
WireConnection;3;0;59;0
WireConnection;3;1;35;0
WireConnection;3;2;43;0
WireConnection;63;0;3;0
WireConnection;45;0;65;0
WireConnection;0;2;64;0
WireConnection;0;9;45;3
ASEEND*/
//CHKSM=CA264D370B19871866D972482A07F172E17368DD