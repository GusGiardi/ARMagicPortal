Shader "GRD/Skybox"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (1,1,1,1)
		_TopColor("Top Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		Stencil{
		  Ref 1
		  Comp Equal
		}
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Front
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD1;
            };

            float4 _BaseColor;
            float4 _TopColor;

			uniform fixed3 _PortalPos;
			uniform fixed3 _PortalDir;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = lerp(_BaseColor, _TopColor, i.uv.y * 2 - 0.5);
				if (dot(i.worldPos - _PortalPos, _PortalDir) < 0)
				{
					col.a = 0;
				}
                return col;
            }
            ENDCG
        }
    }
}
