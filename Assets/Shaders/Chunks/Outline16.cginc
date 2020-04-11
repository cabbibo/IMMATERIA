      

      #include "../Chunks/Struct16.cginc"


      struct vertexOutput
      {
        float4 pos : SV_POSITION;
        float4 color : COLOR;
      };

      vertexOutput vert(uint id : SV_VertexID)
      {
        vertexOutput output;


        Vert v = _TransferBuffer[id];

        float3 newPos = v.pos;

        // normal extrusion technique
        float3 normal = normalize(v.nor);
        newPos += float4(normal, 0.0) * _OutlineExtrusion;

        // convert to world space
        output.pos = mul(UNITY_MATRIX_VP, float4(newPos,1));

        output.color = _OutlineColor;
        return output;
      }