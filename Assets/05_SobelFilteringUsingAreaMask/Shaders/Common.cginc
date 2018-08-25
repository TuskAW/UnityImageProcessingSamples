#ifndef __COMMON__
#define __COMMON__

#include "UnityCG.cginc"

struct v2f
{
    float4 pos : SV_POSITION;
    float4 grabPos : TEXCOORD0;
};  

v2f vs(float4 vertex : POSITION)
{
    v2f vsout;
    vsout.pos = UnityObjectToClipPos(vertex);
    vsout.grabPos = ComputeGrabScreenPos(vsout.pos);
    return vsout;
}

[maxvertexcount(4)]
void gs(triangle v2f input[3], uint primId : SV_PrimitiveID, inout TriangleStream<v2f> outStream)
{
    if(primId > 0)
    {
        return;
    }

    v2f out1;
    out1.pos = float4(-1, -1, 1, 1);
    out1.grabPos = ComputeGrabScreenPos(out1.pos);
    outStream.Append(out1);

    v2f out2;
    out2.pos = float4(1, -1, 1, 1);
    out2.grabPos = ComputeGrabScreenPos(out2.pos);
    outStream.Append(out2);

    v2f out3;
    out3.pos = float4(-1, 1, 1, 1);
    out3.grabPos = ComputeGrabScreenPos(out3.pos);
    outStream.Append(out3);

    v2f out4;
    out4.pos = float4(1, 1, 1, 1);
    out4.grabPos = ComputeGrabScreenPos(out4.pos);
    outStream.Append(out4);

    outStream.RestartStrip();
}

#endif // __COMMON__