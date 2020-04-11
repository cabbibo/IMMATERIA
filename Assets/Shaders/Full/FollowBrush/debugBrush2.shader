
Shader "Brush/debug2" {
    Properties {

    _Color ("Color", Color) = (1,1,1,1)
    _Color2 ("Color2", Color) = (1,1,1,1)
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
      #include "../../Chunks/Struct16.cginc"
      



      uniform int _Count;
      uniform float _Size;
      uniform float3 _Color;
      uniform float3 _Color2;

      uniform sampler2D _AudioMap;

      
      
      StructuredBuffer<Vert> _VertBuffer;


      //uniform float4x4 worldMat;

      //A simple input struct for our pixel shader step containing a position.
      struct varyings {
          float4 pos      : SV_POSITION;
          float3 nor      : TEXCOORD0;
          float3 worldPos : TEXCOORD1;
          float3 eye      : TEXCOORD2;
          float3 debug    : TEXCOORD3;
          float2 uv       : TEXCOORD4;
          float2 uv2       : TEXCOORD6;
          float id        : TEXCOORD5;
          int upDown        : TEXCOORD7;
      };


int _CountMultiplier;
int _VertsPerVert;
//Our vertex function simply fetches a point from the buffer corresponding to the vertex index
//which we transform with the view-projection matrix before passing to the pixel program.
varyings vert (uint id : SV_VertexID){

  varyings o;
  
  int base = id / 6;
  int alternate = id %6;

  int upDown = base % 2;
  

  if( base < _Count * _CountMultiplier ){

      float3 extra = float3(0,0,0);


    

    
      Vert v = _VertBuffer[(base/_CountMultiplier)];

    float3 l = UNITY_MATRIX_V[0].xyz;
    float3 u = UNITY_MATRIX_V[1].xyz;
    float2 fUV = v.uv;
    float2 dUV = v.uv;


        if( (base/_CountMultiplier)%_VertsPerVert != 0){
            Vert vD = _VertBuffer[(base/_CountMultiplier)-1];
            float3 dif = vD.pos - v.pos;
            
            if( upDown == 1 ){
                    l = dif;
                    u = cross(normalize(dif), cross(UNITY_MATRIX_V[0].xyz,UNITY_MATRIX_V[1].xyz));
            }
            dUV = vD.uv;
        }else{
          
          if( upDown == 1 ){
                  l = 0;
                  u = 0;
          }
            dUV = float2(0,0);
        }


    
    
    float2 uv = float2(0,0);

  float fSize = _Size * (1-v.uv.x);


    if( upDown == 0 ){
        if( alternate == 0 ){ extra = fSize*( -l - u); uv = float2(0,0); }
        if( alternate == 1 ){ extra = fSize*(  l - u); uv = float2(1,0); }
        if( alternate == 2 ){ extra = fSize*(  l + u); uv = float2(1,1); }
        if( alternate == 3 ){ extra = fSize*( -l - u); uv = float2(0,0); }
        if( alternate == 4 ){ extra = fSize*(  l + u); uv = float2(1,1); }
        if( alternate == 5 ){ extra = fSize*( -l + u); uv = float2(0,1); }
    }else{

  
        if( alternate == 0 ){ extra = -fSize*.5*u; uv = float2(0,0); fUV = v.uv; }
        if( alternate == 1 ){ extra =  l -fSize*.5*u; uv = float2(1,0);fUV =dUV; }
        if( alternate == 2 ){ extra = l +fSize*.5*u; uv = float2(1,1); fUV = dUV;}
        if( alternate == 3 ){ extra =  -fSize*.5*u; uv = float2(0,0); fUV = v.uv;}
        if( alternate == 4 ){ extra = l +fSize*.5*u; uv = float2(1,1);  fUV = dUV;}
        if( alternate == 5 ){ extra = fSize*.5*u; uv = float2(0,1);fUV = v.uv; }
    }
   



      o.worldPos = (v.pos) + extra;


      //Vert v = _VertBuffer[base % _Count];
      o.eye = _WorldSpaceCameraPos - o.worldPos;
      o.nor =v.nor;
      o.uv = fUV;
      o.uv2 = uv;
      o.id = base;
      o.upDown = upDown;
      o.pos = mul (UNITY_MATRIX_VP, float4(o.worldPos,1.0f));

  }

  return o;

}




      //Pixel function returns a solid color for each point.
      float4 frag (varyings v) : COLOR {

          float3 col = _Color;

          float lookup = v.uv.x * .9;
          float4 aCol = tex2D(_AudioMap,lookup);
          if( v.upDown == 0 ){
            
            col = _Color2;
            lookup += length( v.uv2 - .5 ) * .1;
            if( length( v.uv2 -.5) > .5 ){ discard;}
          }
          
            col *= (1-v.uv.x);

            col = aCol.xyz;
          return float4(col,1 );
      }

      ENDCG

    }
  }


}