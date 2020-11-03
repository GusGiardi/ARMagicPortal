Shader "GRD/Ground"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ReliefTex("Relief", 2D) = "white" {}
		_MaxRelief("Max Relief", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		Stencil{
		  Ref 1
		  Comp Equal
		}
		Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float2 reliefuv : TEXCOORD1;
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
			sampler2D _ReliefTex;
			float4 _ReliefTex_ST;

			float _MaxRelief;

			uniform fixed3 _PortalPos;
			uniform fixed3 _PortalDir;

            v2f vert (appdata v)
            {
                v2f o;
				float2 reliefMap = TRANSFORM_TEX(v.reliefuv, _ReliefTex);
				fixed4 relief = tex2Dlod(_ReliefTex, float4(reliefMap.xy,0,0));
                o.vertex = UnityObjectToClipPos(float3(v.vertex.x, v.vertex.y + relief.x *_MaxRelief, v.vertex.z));
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
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
