#ifndef __PREPROCESS__
#define __PREPROCESS__

#include "UnityCG.cginc"
#include "Common.cginc"

float _OutlineWidth;
float4 _BackgroundMaskColor;
float4 _OutlineMaskColor;
float4 _ObjectMaskColor;

struct appdata
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
};

v2f vsOutlineUsingLocalPos (appdata v)
{
    float3 direction = normalize(v.vertex.xyz);
    float distance = UnityObjectToViewPos(v.vertex).z;
    v.vertex.xyz += direction * -distance * _OutlineWidth;

    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.grabPos = ComputeGrabScreenPos(o.pos);
    return o;
}

v2f vsOutlineUsingNormal (appdata v)
{
    float3 direction = v.normal;
    float distance = UnityObjectToViewPos(v.vertex).z;
    v.vertex.xyz += direction * -distance * _OutlineWidth;

    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.grabPos = ComputeGrabScreenPos(o.pos);
    return o;
}

fixed4 fsMaskBackground(v2f i) : SV_Target
{
    return _BackgroundMaskColor;
}

fixed4 fsMaskOutline(v2f i) : SV_Target
{
    return _OutlineMaskColor;
}

fixed4 fsMaskObject(v2f i) : SV_Target
{
    return _ObjectMaskColor;
}

#endif // __PREPROCESS__