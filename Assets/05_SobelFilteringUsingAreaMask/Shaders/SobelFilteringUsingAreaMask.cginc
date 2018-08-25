#ifndef __SOBEL_MAIN__
#define __SOBEL_MAIN__

#include "UnityCG.cginc"
#include "Common.cginc"

static const int samplingCount = 3*3;
static const half Kx[samplingCount] = {-1, -2, -1,
                                        0,  0,  0,
                                        1,  2,  1};
static const half Ky[samplingCount] = {-1, 0, 1,
                                       -2, 0, 2,
                                       -1, 0, 1};

sampler2D _FrameBuffer;
sampler2D _MaskBuffer;
float4 _FrameBuffer_TexelSize;
float4 _TargetMaskColor;

fixed4 fsBackground (v2f i) : SV_Target
{
    float2 grabUV = (i.grabPos.xy / i.grabPos.w);
    return tex2D(_FrameBuffer, grabUV);
}

fixed4 fsSobelFilter (v2f i) : SV_Target
{
    float2 grabUV = (i.grabPos.xy / i.grabPos.w);
    float du = _FrameBuffer_TexelSize.x;
    float dv = _FrameBuffer_TexelSize.y;

    // Get colors
    half3 col0 = tex2D(_FrameBuffer, grabUV + float2(-du, dv));
    half3 col1 = tex2D(_FrameBuffer, grabUV + float2(0.0, dv));
    half3 col2 = tex2D(_FrameBuffer, grabUV + float2( du, dv));
    half3 col3 = tex2D(_FrameBuffer, grabUV + float2(-du,0.0));
    half3 col4 = tex2D(_FrameBuffer, grabUV);
    half3 col5 = tex2D(_FrameBuffer, grabUV + float2( du,0.0));
    half3 col6 = tex2D(_FrameBuffer, grabUV + float2(-du,-dv));
    half3 col7 = tex2D(_FrameBuffer, grabUV + float2(0.0,-dv));
    half3 col8 = tex2D(_FrameBuffer, grabUV + float2( du,-dv));

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

fixed4 fsSobelFilterUsingAreaMask(v2f i) : SV_Target
{
    fixed4 filtered = fsSobelFilter(i);
    fixed4 background = fsBackground(i);

    float2 grabUV = (i.grabPos.xy / i.grabPos.w);
    float4 maskColor = tex2D(_MaskBuffer, grabUV);
    float4 diff = _TargetMaskColor - maskColor;

    fixed4 color = (length(diff) <= 0.001f) ? filtered : background;

    return color;
}

#endif // __SOBEL_MAIN__