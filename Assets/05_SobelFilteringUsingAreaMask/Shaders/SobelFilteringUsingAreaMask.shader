Shader "Hidden/SobelFilteringUsingAreaMask"
{
    Properties
    {
        _TargetMaskColor("Target Mask Color", Color) = (1, 0, 0, 1)
        _OutlineWidth("Outline Width", float) = 0.1
        _BackgroundMaskColor("Background Mask Color", Color) = (0, 1, 0, 1)
        _OutlineMaskColor("Outline Mask Color", Color) = (0, 0, 1, 1)
        _ObjectMaskColor("Object Mask Color", Color) = (1, 0, 0, 1)
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"
    #include "Preprocess.cginc"
    #include "SobelFilteringUsingAreaMask.cginc"
    ENDCG

    Subshader
    {
        Tags
        {
            "Queue" = "Transparent-10"
            "RenderType" = "Transparent"
        }

        // 0: Preprocessing (Grab frame buffer)
        GrabPass
        {
            "_FrameBuffer"
        }

        // 1: Preprocessing (Background mask)
        Pass
        {
            Cull Off ZWrite Off ZTest Less

            CGPROGRAM
            #pragma vertex vs
            #pragma geometry gs
            #pragma fragment fsMaskBackground
            ENDCG
        }

        // 2: Preprocessing (Outline mask)
        Pass
        {
            Cull Off ZWrite Off ZTest Less

            CGPROGRAM
            #pragma vertex vsOutlineUsingLocalPos
            #pragma fragment fsMaskOutline
            ENDCG
        }

        // 3: Preprocessing (Object mask)
        Pass
        {
            Cull Off ZWrite Off ZTest Less

            CGPROGRAM
            #pragma vertex vs
            #pragma fragment fsMaskObject
            ENDCG
        }

        // 4: Preprocessing (Grab frame buffer)
        GrabPass
        {
            "_MaskBuffer"
        }

        // 5: Sobel filtering
        Pass
        {
            Cull Off ZWrite Off ZTest Less

            CGPROGRAM
            #pragma vertex vs
            #pragma geometry gs
            #pragma fragment fsSobelFilterUsingAreaMask
            ENDCG
        }
    }
}
