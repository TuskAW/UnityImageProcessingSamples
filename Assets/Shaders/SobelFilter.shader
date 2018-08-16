Shader "Hidden/SobelFilter"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
				return o;
			}

			static const int samplingCount = 3*3;
			static const half Kx[samplingCount] = {-1, -2, -1,
												    0,  0,  0,
													1,  2,  1};
			static const half Ky[samplingCount] = {-1, 0, 1,
												   -2, 0, 2,
												   -1, 0, 1};

			sampler2D _MainTex;
			float4 _MainTex_TexelSize;

			fixed4 frag (v2f i) : SV_Target
			{
				// Get colors
				float du = _MainTex_TexelSize.x;
				float dv = _MainTex_TexelSize.y;
				half3 col0 = tex2D(_MainTex, i.uv + half2(-du, dv));
				half3 col1 = tex2D(_MainTex, i.uv + half2(0.0, dv));
				half3 col2 = tex2D(_MainTex, i.uv + half2( du, dv));
				half3 col3 = tex2D(_MainTex, i.uv + half2(-du,0.0));
				half3 col4 = tex2D(_MainTex, i.uv);
				half3 col5 = tex2D(_MainTex, i.uv + half2( du,0.0));
				half3 col6 = tex2D(_MainTex, i.uv + half2(-du,-dv));
				half3 col7 = tex2D(_MainTex, i.uv + half2(0.0,-dv));
				half3 col8 = tex2D(_MainTex, i.uv + half2( du,-dv));

				// Horizontal edge detection
				half3 cx = 0.0;
				cx += col0 * Kx[0];
				cx += col1 * Kx[1];
				cx += col2 * Kx[2];
				cx += col3 * Kx[3];
				cx += col4 * Kx[4];
				cx += col5 * Kx[5];
				cx += col6 * Kx[6];
				cx += col7 * Kx[7];
				cx += col8 * Kx[8];

				// Vertical edge detection
				half3 cy = 0.0;
				cy += col0 * Ky[0];
				cy += col1 * Ky[1];
				cy += col2 * Ky[2];
				cy += col3 * Ky[3];
				cy += col4 * Ky[4];
				cy += col5 * Ky[5];
				cy += col6 * Ky[6];
				cy += col7 * Ky[7];
				cy += col8 * Ky[8];

				half3 col = sqrt(cx*cx + cy*cy);

				return fixed4(col, 1.0);
			}
			ENDCG
		}
	}
}
