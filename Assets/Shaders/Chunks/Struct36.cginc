#if defined( SHADER_API_D3D11 )
  struct Vert{

    float3 pos;
    float3 vel;
    float3 nor;
    float3 tan;
    float2 uv;
  
    float used;
  
   
    float3 targetPos;
    float3 bindPos;
    float3 bindNor;
    float3 bindTan;

    float4 boneWeights;
    float4 boneIDs;

    float debug;

  };

#endif

#if defined( SHADER_API_METAL )       
      struct Vert{

    float3 pos;
    float3 vel;
    float3 nor;
    float3 tan;
    float2 uv;
  
    float used;
  
   
    float3 targetPos;
    float3 bindPos;
    float3 bindNor;
    float3 bindTan;

    float4 boneWeights;
    float4 boneIDs;

    float debug;

  };
#endif


#if defined(SHADER_API_METAL)
  StructuredBuffer<Vert> _TransferBuffer;
#endif

#if defined(SHADER_API_D3D11) 
  StructuredBuffer<Vert> _TransferBuffer;
#endif




