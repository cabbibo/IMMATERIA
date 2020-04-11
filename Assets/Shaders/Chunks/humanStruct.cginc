  struct Head{

  float4x4 localToWorld;
  float4x4 worldToLocal;
  float3 pos;
  float3 debug;

};

struct Hand{

  float4x4 localToWorld;
  float4x4 worldToLocal;
  float3 pos;
  float3 vel;
  float trigger;
  float3 debug;

};


struct Human{

  Head head;
  Hand hand1;
  Hand hand2;

};
