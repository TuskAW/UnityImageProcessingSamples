Shader "Hidden/StencilWriter"
{
    Properties
    {
        _StencilRef("Stencil Reference", Int) = 1
        _Transparency("Transparency", Range(0.0,0.5)) = 0.1
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha

        Stencil
        {
            Ref [_StencilRef]
            Comp Always
            Pass Replace
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float _Transparency;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = fixed4(1.0, 0.0, 0.0, _Transparency);
                return color;
            }
            ENDCG
        }
    }
}
