 #include "UnityCG.cginc"
#include "../Chunks/StructIfDefs.cginc"


  struct v2f {
        V2F_SHADOW_CASTER;
        float2 uv : TEXCOORD1;
      };


      v2f vert(appdata_base v, uint id : SV_VertexID)
      {
        v2f o;
        o.uv = _TransferBuffer[id].uv;
        o.pos = mul(UNITY_MATRIX_VP, float4(_TransferBuffer[id].pos, 1));
        return o;
      }

      float4 frag(v2f i) : COLOR
      {
        float4 col = tex2D(_Tex,i.uv);
        if( col.a < .1){discard;}
        SHADOW_CASTER_FRAGMENT(i)
      }