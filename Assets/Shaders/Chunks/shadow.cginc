
#include "UnityCG.cginc"
#include "../Chunks/StructIfDefs.cginc"


struct v2f {
  V2F_SHADOW_CASTER;
};


v2f vert(appdata_base v, uint id : SV_VertexID)
{
  v2f o;
  o.pos = mul(UNITY_MATRIX_VP, float4(_TransferBuffer[id].pos, 1));
  return o;
}

float4 frag(v2f i) : COLOR
{
  SHADOW_CASTER_FRAGMENT(i)
}