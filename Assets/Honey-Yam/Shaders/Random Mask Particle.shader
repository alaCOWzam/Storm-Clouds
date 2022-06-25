// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Honey-Yam/Random Mask Particle"
{
	Properties
	{
		[HDR]_Colour("Colour", Color) = (1,1,1,1)
		_Texture("Texture", 2D) = "white" {}
		_TexturePower("Texture Power", Float) = 1
		_ParticleRandomUV("Particle Random UV", Range( 0 , 1)) = 0
		_ParticleRandomMask("Particle Random Mask", Range( 0 , 1)) = 0
		_MaskRemapMin("Mask Remap Min", Range( 0 , 1)) = 0
		_MaskRemapMax("Mask Remap Max", Range( 0 , 1)) = 1
		_MaskPower("Mask Power", Float) = 1
		_InnerMaskRemapMin("Inner Mask Remap Min", Range( 0 , 1)) = 0
		_InnerMaskRemapMax("Inner Mask Remap Max", Range( 0 , 1)) = 1
		_InnerMaskPower("Inner Mask Power", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
			float4 uv2_texcoord2;
		};

		uniform float4 _Colour;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _ParticleRandomUV;
		uniform float _TexturePower;
		uniform float _MaskRemapMin;
		uniform float _MaskRemapMax;
		uniform float _MaskPower;
		uniform float _ParticleRandomMask;
		uniform float _InnerMaskRemapMin;
		uniform float _InnerMaskRemapMax;
		uniform float _InnerMaskPower;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_Texture = i.uv_texcoord;
			uvs_Texture.xy = i.uv_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
			float2 appendResult57 = (float2(i.uv2_texcoord2.x , i.uv2_texcoord2.y));
			float2 ParticleStableRandomZW47 = appendResult57;
			float4 temp_cast_0 = (_TexturePower).xxxx;
			float4 Texture41 = pow( tex2D( _Texture, ( uvs_Texture.xy + ( ( ( ParticleStableRandomZW47 - float2( 0.5,0.5 ) ) * float2( 2,2 ) ) * _ParticleRandomUV ) ) ) , temp_cast_0 );
			float4 ParticleColour22 = ( _Colour * i.vertexColor * Texture41 );
			float2 uvs_TexCoord1 = i.uv_texcoord;
			uvs_TexCoord1.xy = i.uv_texcoord.xy * float2( 2,2 ) + float2( -1,-1 );
			float temp_output_1_0_g2 = _MaskRemapMin;
			float Mask4 = pow( saturate( ( ( saturate( ( 1.0 - length( uvs_TexCoord1.xy ) ) ) - temp_output_1_0_g2 ) / ( _MaskRemapMax - temp_output_1_0_g2 ) ) ) , _MaskPower );
			float2 uvs_TexCoord6 = i.uv_texcoord;
			uvs_TexCoord6.xy = i.uv_texcoord.xy * float2( 2,2 ) + float2( -1,-1 );
			float2 appendResult31 = (float2(i.uv_texcoord.z , i.uv_texcoord.w));
			float2 ParticleStableRandomXY29 = appendResult31;
			float temp_output_1_0_g1 = _InnerMaskRemapMin;
			float Mask215 = pow( saturate( ( ( saturate( ( 1.0 - length( ( uvs_TexCoord6.xy + ( ( ( ParticleStableRandomXY29 - float2( 0.5,0.5 ) ) * float2( 2,2 ) ) * _ParticleRandomMask ) ) ) ) ) - temp_output_1_0_g1 ) / ( _InnerMaskRemapMax - temp_output_1_0_g1 ) ) ) , _InnerMaskPower );
			float4 temp_output_18_0 = ( ParticleColour22 * Mask4 * Mask215 );
			o.Emission = temp_output_18_0.rgb;
			o.Alpha = temp_output_18_0.a;
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
				float4 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				half4 color : COLOR0;
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
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.customPack2.xyzw = customInputData.uv2_texcoord2;
				o.customPack2.xyzw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				surfIN.uv_texcoord = IN.customPack1.xyzw;
				surfIN.uv2_texcoord2 = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
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
0;619.3334;851.6667;739.6667;4150.217;322.6143;1.229548;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;30;-4079.657,-1154.527;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;31;-3829.27,-1088.92;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;46;-4060.646,-860.8019;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-3631.707,-1096.748;Inherit;False;ParticleStableRandomXY;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-3811.573,-844.9253;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-3605.192,-844.3192;Inherit;False;ParticleStableRandomZW;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-5111.24,838.4697;Inherit;False;29;ParticleStableRandomXY;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-4769.622,830.9513;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-2377.908,-580.2807;Inherit;False;47;ParticleStableRandomZW;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-4745.286,982.3295;Inherit;False;Property;_ParticleRandomMask;Particle Random Mask;4;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-4540.272,829.4172;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;-2052.921,-572.8383;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-4292.978,825.67;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-4382.73,651.2652;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;-1,-1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1863.138,-575.3192;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2124.719,-432.8359;Inherit;False;Property;_ParticleRandomUV;Particle Random UV;3;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-4722,-50.49919;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;-1,-1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1606.375,-566.6364;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-1750.624,-766.2771;Inherit;False;0;40;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-4045.524,743.096;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-1.25,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;2;-4423.308,-34.71898;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;7;-3851.078,789.2662;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-1327.18,-692.1371;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;3;-4215.708,-49.95209;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;-3633.268,780.0685;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-999.4133,-466.8854;Inherit;False;Property;_TexturePower;Texture Power;2;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-1101.495,-695.0681;Inherit;True;Property;_Texture;Texture;1;0;Create;True;0;0;0;False;0;False;-1;None;c21691e7991853d48a376c06baee1159;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;45;-641.4138,-648.8854;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;56;-3406.202,783.8945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-4154.024,-273.4851;Inherit;False;Property;_MaskRemapMin;Mask Remap Min;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-3970.28,-49.9863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-3584.478,550.4163;Inherit;False;Property;_InnerMaskRemapMin;Inner Mask Remap Min;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-3585.2,649.06;Inherit;False;Property;_InnerMaskRemapMax;Inner Mask Remap Max;9;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-4170.024,-171.4853;Inherit;False;Property;_MaskRemapMax;Mask Remap Max;6;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-351.3066,-612.3519;Inherit;False;Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;51;-3750.024,-91.48531;Inherit;False;Inverse Lerp;-1;;2;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-3171.272,673.1204;Inherit;False;Inverse Lerp;-1;;1;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3869.199,108.5382;Inherit;False;Property;_MaskPower;Mask Power;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;21;-1571.964,200.8365;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-1591.304,-15.60804;Inherit;False;Property;_Colour;Colour;0;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;12.99604,12.99604,12.99604,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1579.042,406.5497;Inherit;False;41;Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;11;-2959.432,677.798;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-3147.442,850.4621;Inherit;False;Property;_InnerMaskPower;Inner Mask Power;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;65;-3525.607,-52.52372;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1179.918,129.3507;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;54;-2769.142,698.3624;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;48;-3298.486,-37.93697;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-956.9989,128.0696;Inherit;False;ParticleColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-3019.095,-20.74605;Inherit;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-2534.303,680.4816;Inherit;True;Mask2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;203.2207,169.4784;Inherit;False;22;ParticleColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;196.9485,437.9857;Inherit;False;15;Mask2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;184.3856,301.8495;Inherit;False;4;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;594.0322,298.0685;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;25;922.8367,364.5101;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1184.328,139.8758;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Random Mask Particle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;30;3
WireConnection;31;1;30;4
WireConnection;29;0;31;0
WireConnection;57;0;46;1
WireConnection;57;1;46;2
WireConnection;47;0;57;0
WireConnection;39;0;33;0
WireConnection;36;0;39;0
WireConnection;62;0;60;0
WireConnection;34;0;36;0
WireConnection;34;1;35;0
WireConnection;61;0;62;0
WireConnection;63;0;61;0
WireConnection;63;1;64;0
WireConnection;13;0;6;0
WireConnection;13;1;34;0
WireConnection;2;0;1;0
WireConnection;7;0;13;0
WireConnection;59;0;58;0
WireConnection;59;1;63;0
WireConnection;3;0;2;0
WireConnection;5;0;7;0
WireConnection;40;1;59;0
WireConnection;45;0;40;0
WireConnection;45;1;44;0
WireConnection;56;0;5;0
WireConnection;27;0;3;0
WireConnection;41;0;45;0
WireConnection;51;1;52;0
WireConnection;51;2;53;0
WireConnection;51;3;27;0
WireConnection;8;1;9;0
WireConnection;8;2;10;0
WireConnection;8;3;56;0
WireConnection;11;0;8;0
WireConnection;65;0;51;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;20;2;42;0
WireConnection;54;0;11;0
WireConnection;54;1;55;0
WireConnection;48;0;65;0
WireConnection;48;1;49;0
WireConnection;22;0;20;0
WireConnection;4;0;48;0
WireConnection;15;0;54;0
WireConnection;18;0;23;0
WireConnection;18;1;16;0
WireConnection;18;2;17;0
WireConnection;25;0;18;0
WireConnection;0;2;18;0
WireConnection;0;9;25;3
ASEEND*/
//CHKSM=EFEA2AF881E149EBBB0D71684E70156142B9AD34