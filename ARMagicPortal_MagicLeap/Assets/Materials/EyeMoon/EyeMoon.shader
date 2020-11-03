Shader "GRD/EyeMoon"
{
    Properties
    {
        [NoScaleOffset]_EyelidTex ("Eyelid Texture", 2D) = "white" {}
		[NoScaleOffset]_EyeballTex ("Eyeball Texture", 2D) = "white" {}
		[NoScaleOffset]_EyeMask ("Eye Mask", 2D) = "white" {}

		_EyeDirection ("Eye Direction", Vector)= (0,0,0,0)
		_EyeRadius ("Eye Radius", float) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
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

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float2 uvEyeBall : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float2 uvEyeBall : TEXCOORD1;
                float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD2;
            };

            sampler2D _EyelidTex;
            sampler2D _EyeballTex;
            sampler2D _EyeMask;
            float4 _EyelidTex_ST;
            float4 _EyeballTex_ST;

			float2 _EyeDirection;
			float _EyeRadius;

			uniform fixed3 _PortalPos;
			uniform fixed3 _PortalDir;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _EyelidTex);
				//o.uvEyeBall = TRANSFORM_TEX(v.uvEyeBall, _EyeballTex);
				float2 eyeDir = length(_EyeDirection) > 1 ? normalize(_EyeDirection) : _EyeDirection;
				o.uvEyeBall = v.uvEyeBall + float2(eyeDir.x, -eyeDir.y) * _EyeRadius;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_EyelidTex, i.uv);
				fixed4 mask = tex2D(_EyeMask, i.uv);
				fixed4 eyeballCol = tex2D(_EyeballTex, i.uvEyeBall);
				eyeballCol *= mask.r;

				if (dot(i.worldPos - _PortalPos, _PortalDir) < 0)
				{
					col.a = 0;
					eyeballCol.a = 0;
				}

                return col * col.a + eyeballCol * eyeballCol.a;
            }
            ENDCG
        }
    }
}
