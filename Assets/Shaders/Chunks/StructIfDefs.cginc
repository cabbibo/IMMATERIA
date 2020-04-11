#pragma multi_compile Enable9Struct Enable12Struct Enable16Struct Enable24Struct Enable36Struct


#if defined( SHADER_API_D3D11 )      
  #if defined(Enable9Struct)
    struct Vert{
      float3 pos;
      float3 nor;
      float2 uv;
      float debug;
    };
  #elif defined(Enable12Struct)
    struct Vert{
      float3 pos;
      float3 nor;
      float3 tan;
      float2 uv;
      float debug;
    };

  #elif defined(Enable16Struct)
    struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };
  #elif defined(Enable24Struct)
    struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tang;
      float2 uv;
      float used;
      float3 triIDs;
      float3 triWeights;
      float3 debug;
    };
  #elif defined(Enable36Struct)
    struct Vert{

      float3 pos;
      float3 vel;
      float3 nor;
      float3 tang;
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
  #else
    struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };
  #endif
#endif

#if defined( SHADER_API_METAL )       
  #if defined(Enable9Struct)
    struct Vert{
      float3 pos;
      float3 nor;
      float2 uv;
      float debug;
    };
  #elif defined(Enable12Struct)
    struct Vert{
      float3 pos;
      float3 nor;
      float3 tan;
      float2 uv;
      float debug;
    };

  #elif defined(Enable16Struct)
    struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };
  #elif defined(Enable24Struct)
    struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tang;
      float2 uv;
      float used;
      float3 triIDs;
      float3 triWeights;
      float3 debug;
    };
  #elif defined(Enable36Struct)
    struct Vert{

      float3 pos;
      float3 vel;
      float3 nor;
      float3 tang;
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
  #else
    struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };
  #endif
#endif


#if defined(SHADER_API_METAL)
  StructuredBuffer<Vert> _TransferBuffer;
#endif

#if defined(SHADER_API_D3D11) 
  StructuredBuffer<Vert> _TransferBuffer;
#endif


