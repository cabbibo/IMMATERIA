Shader "Debug/SDFBoneDebug" {
    Properties {

    _Color ("Color", Color) = (1,1,1,1)
    _Size ("Size", float) = .01
    }


  SubShader{
    Cull Off
    Pass{

      CGPROGRAM
      
      #pragma target 4.5

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"



      uniform int _Count;
      uniform float _Size;
      uniform float3 _Color;

    
#if SHADER_API_D3D11 || SHADER_API_METAL || SHADER_API_VULKAN || SHADER_API_GLES3 || SHADER_API_GLCORE
    struct Vert{
      float3 start;
      float3 end;
      float size;
      float id;
    };

  StructuredBuffer<Vert> _VertBuffer;   
#endif
 


      //uniform float4x4 worldMat;

      //A simple input struct for our pixel shader step containing a position.
      struct varyings {
          float4 pos      : SV_POSITION;
      };

//Our vertex function simply fetches a point from the buffer corresponding to the vertex index
//which we transform with the view-projection matrix before passing to the pixel program.
varyings vert (uint id : SV_VertexID){

  varyings o;

  int base = id / 6;
  int alternate = id %6;

  if( base < _Count ){

      float3 extra = float3(0,0,0);

    float3 l = UNITY_MATRIX_V[0].xyz;
    float3 u = UNITY_MATRIX_V[1].xyz;


      Vert v = _VertBuffer[base % _Count];

    float3 dif = v.end - v.start;
    float3 left = normalize( cross(dif,UNITY_MATRIX_V[2].xyz));
    left *= v.size;
    
    float2 uv = float2(0,0);

    float3 fPos = v.start;

    if( alternate == 0 ){ fPos = fPos - left; uv = float2(0,0); }
    if( alternate == 1 ){ fPos =  fPos + left ; uv = float2(1,0); }
    if( alternate == 2 ){ fPos =  fPos + left + dif ; uv = float2(1,1); }
    if( alternate == 3 ){ fPos = fPos - left; uv = float2(0,0); }
    if( alternate == 4 ){ fPos =  fPos + left + dif ; uv = float2(1,1); }
    if( alternate == 5 ){ fPos = fPos - left + dif ; uv = float2(0,1); }



      o.pos = mul (UNITY_MATRIX_VP, float4(fPos,1.0f));

  }

  return o;

}




//Pixel function returns a solid color for each point.
float4 frag (varyings v) : COLOR {
    return float4(_Color,1 );
}

      ENDCG

    }
  }

  Fallback Off


}
