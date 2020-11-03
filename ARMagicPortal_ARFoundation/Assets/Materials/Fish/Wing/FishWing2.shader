Shader "GRD/FishWing2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color1("Color 1", Color) = (1,0,0,1)
		_Color2("Color 2", Color) = (0,1,0,1)
		_Color3("Color 3", Color) = (0,0,1,1)
		_BodySize("Body Size", float) = 0
		_BodySpeed("Body Speed", float) = 1
    }

	CGINCLUDE
	//#pragma vertex vert
	//#pragma fragment frag
	// make fog work
	#pragma multi_compile_fog

	#include "UnityCG.cginc"

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		UNITY_FOG_COORDS(1)
		float4 vertex : SV_POSITION;
		float4 grabPos : TEXCOORD1;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;

	float4 _Color1;
	float4 _Color2;
	float4 _Color3;

	float _BodySize;
	float _BodySpeed;

	v2f vertBack(appdata v)
	{
		v2f o;
		
		float3 vertPos = float3(v.vertex.x + cos(max(0, -v.vertex.z) - _Time.y * _BodySpeed) * max(0, -v.vertex.z) * _BodySize * 0, v.vertex.y + cos(abs(v.vertex.x) * 10 - _Time.y) * abs(v.vertex.x), v.vertex.z);
		o.vertex = UnityObjectToClipPos(vertPos);
		
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		UNITY_TRANSFER_FOG(o, o.vertex);
		return o;
	}

	v2f vertFront(appdata v)
	{
		v2f o;
		
		float3 vertPos = float3(v.vertex.x + cos(max(0, -v.vertex.z) - _Time.y * _BodySpeed) * max(0, -v.vertex.z) * _BodySize * 0, v.vertex.y + cos(abs(v.vertex.x) * 10 - _Time.y) * abs(v.vertex.x), v.vertex.z);
		o.vertex = UnityObjectToClipPos(vertPos);

		o.grabPos = ComputeGrabScreenPos(o.vertex);

		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		UNITY_TRANSFER_FOG(o, o.vertex);
		return o;
	}

	sampler2D _BackgroundTexture;

	fixed4 frag(v2f i) : SV_Target
	{
		// sample the texture
		fixed4 col = tex2D(_MainTex, i.uv);
		// apply fog
		UNITY_APPLY_FOG(i.fogCoord, col);
		return col;
	}

	fixed4 fragFront(v2f i) : SV_Target
	{
		fixed4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
		// sample the texture
		fixed4 col = tex2D(_MainTex, i.uv);
		col = lerp(bgcolor, col, col.a);
		// apply fog
		UNITY_APPLY_FOG(i.fogCoord, col);
		return col;
	}
	ENDCG

    SubShader
    {
		Tags{ "Queue" = "Transparent"}

		Pass
		{
			Tags { "RenderType" = "Transparent" }
			LOD 200

			//ZWrite Off
			//ZTest Always
			Cull Back
			Blend SrcAlpha OneMinusSrcAlpha
			AlphaToMask On
			CGPROGRAM
			#pragma vertex vertBack
			#pragma fragment frag
			ENDCG
		}
		Pass
        {
			Tags { "RenderType" = "Transparent" }
			LOD 200

			//ZWrite On
			Cull Front
			Blend SrcAlpha OneMinusSrcAlpha
			AlphaToMask On
			CGPROGRAM
			#pragma vertex vertBack
			#pragma fragment frag
			ENDCG
        }
			GrabPass
		{
			"_BackgroundTexture"
		}
    }
}
