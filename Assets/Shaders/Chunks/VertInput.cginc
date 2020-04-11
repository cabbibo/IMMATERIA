    

      #include "../Chunks/Struct16.cginc"


    int _TransferCount;
      struct vertexInput
      {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
        float4 tan : TANGENT;
        float3 uv : TEXCOORD0;
      };

      struct vertexOutput
      {
        float4 pos : SV_POSITION;
        float3 normal : NORMAL;
        float2 uv : TEXCOORD0;
        float3 world : TEXCOORD3;
        float3 tan : TEXCOORD4;
        float2 debug : TEXCOORD5;
        float3 eye : TEXCOORD6;
        UNITY_SHADOW_COORDS(2)
        //LIGHTING_COORDS(1,2) // shadows
      };

      vertexOutput vert(uint id : SV_VertexID)
      {
        vertexOutput output;
        Vert v = _TransferBuffer[id];




        // convert input to world space
        output.pos = mul(UNITY_MATRIX_VP, float4(v.pos,1));//UnityObjectToClipPos(input.vertex);
        //float4 normal4 = float4(input.normal, 0.0); // need float4 to mult with 4x4 matrix
        output.normal = v.nor;////normalize(mul(normal4, unity_WorldToObject).xyz);
        output.tan = v.tan;//input.tan.w * normalize(mul(input.tan, unity_WorldToObject).xyz);
        output.world = v.pos;//mul(unity_ObjectToWorld, input.vertex).xyz;
        output.uv = v.uv;//input.texCoord;
        output.debug = v.debug;
        output.eye = v.pos-_WorldSpaceCameraPos;

        UNITY_TRANSFER_SHADOW(output,output.world);


        //TRANSFER_VERTEX_TO_FRAGMENT(output); // shadows
        return output;
      }
