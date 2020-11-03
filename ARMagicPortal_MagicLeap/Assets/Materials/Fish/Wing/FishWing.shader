Shader "GRD/FishWing"
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
    SubShader
    {
        Tags { "RenderType"="Transparent" }
		Stencil{
		  Ref 1
		  Comp Equal
		}
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask On
        LOD 100
		
        Pass
        {
			Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
			#pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			float4 _Color1;
			float4 _Color2;
			float4 _Color3;

			float _BodySize;
			float _BodySpeed;

			uniform fixed3 _PortalPos;
			uniform fixed3 _PortalDir;

            v2f vert (appdata v)
            {
                v2f o;

				UNITY_SETUP_INSTANCE_ID(v);

                o.vertex = UnityObjectToClipPos(float3(v.vertex.x + cos(max(0, -v.vertex.z) - _Time.y * _BodySpeed) * max(0, -v.vertex.z) * _BodySize, v.vertex.y + cos(abs(v.vertex.x) * 10 - _Time.y) * abs(v.vertex.x), v.vertex.z));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				if (dot(i.worldPos - _PortalPos, _PortalDir) < 0)
				{
					col.a = 0;
				}
				clip(col.a - 0.1);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
