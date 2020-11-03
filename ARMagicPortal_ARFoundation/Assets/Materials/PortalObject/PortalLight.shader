Shader "Unlit/PortalLight"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_ElipseRadius("Elipse Radius", Vector) = (1,1,2,2)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float3 vertexLocalPostion : TEXCOORD0;
            };

            float4 _Color;
			float4 _ElipseRadius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertexLocalPostion = v.vertex;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;
				fixed2 alpha = lerp(fixed2(1, 1), fixed2(0, 0), smoothstep(abs(_ElipseRadius.xy), abs(_ElipseRadius.zw), abs(i.vertexLocalPostion.xz)));
				col.a = alpha.x * alpha.y;

				fixed4 test = fixed4(i.vertexLocalPostion,1);
				//return test;
                return col;
            }
            ENDCG
        }
    }
}
