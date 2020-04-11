
        struct varyings {
          float2 texcoord1;
          float3 tangent;
          float3 normal;
          float3 worldPos;
          float3 eye;
          float2 debug;
      };

        struct Input {
          float2 texcoord1;
          float3 tangent;
          float3 normal;
          float3 worldPos;
          float3 eye;
          float2 debug;
      };

      
       void vert (inout appdata v, out Input data ) {
      
        UNITY_INITIALIZE_OUTPUT( Input , data );
        #if defined(SHADER_API_METAL) || defined(SHADER_API_D3D11)
            float3 fPos =_TransferBuffer[v.id].pos;
            float3 fNor =_TransferBuffer[v.id].nor;
            float3 fTan =_TransferBuffer[v.id].tan;
            float2 fUV =_TransferBuffer[v.id].uv;
          
                v.vertex = float4(fPos,1);// float4(v.vertex.xyz,1.0f);
                v.normal = fNor; //float4(normalize(points[id].normal), 1.0f);
                v.tangent = float4(0,1,0,1);//float4(fTan,1);//float4( normalize(cross(fNor,float3(0,1,0))),1);
                 //v.UV = fUV;
               // v.texcoord1 = fUV;
                data.texcoord1 = fUV;//float2(1,1);
                data.tangent =fTan;
                data.normal =fNor;
                data.eye = fPos - _WorldSpaceCameraPos;
                data.worldPos = fPos;
                data.debug =  _TransferBuffer[v.id].debug;
            #endif
  
         }
 
