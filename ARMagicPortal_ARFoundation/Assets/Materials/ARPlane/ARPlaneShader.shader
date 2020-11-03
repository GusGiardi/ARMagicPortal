Shader "Unlit/ARPlaneShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }

        Pass
        {
			Stencil{
			  Ref 1
			  Comp NotEqual
			}
			Blend SrcAlpha OneMinusSrcAlpha
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
            };

            float4 _Color;

			uniform float _ARPlanesInvisible;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				if (_ARPlanesInvisible == 1) 
				{
					return fixed4(0, 0, 0, 0);
				}
                fixed4 col = _Color;
                return col;
            }
            ENDCG
        }
    }
}
