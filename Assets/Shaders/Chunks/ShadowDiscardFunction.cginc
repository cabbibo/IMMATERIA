

      #include "../Chunks/Struct16.cginc"
      #include "../Chunks/ShadowCasterPos.cginc"
   

      StructuredBuffer<Vert> _VertBuffer;
      StructuredBuffer<int> _TriBuffer;

      struct v2f {
        V2F_SHADOW_CASTER;
        float3 nor : NORMAL;
        float3 worldPos : TEXCOORD1;
        float2 uv : TEXCOORD0;
      };


      v2f vert(appdata_base input, uint id : SV_VertexID)
      {
        v2f o;
        Vert v = _VertBuffer[_TriBuffer[id]];

        float4 position = ShadowCasterPos(v.pos, -v.nor);
        o.pos = UnityApplyLinearShadowBias(position);
        o.worldPos = v.pos;
        o.uv = v.uv;
        return o;
      }

      float4 frag(v2f i) : COLOR
      {

        if( DoShadowDiscard(i.worldPos,i.uv) < .5 ){ discard; }

        SHADOW_CASTER_FRAGMENT(i)
      }