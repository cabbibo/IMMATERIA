Shader "Debug/HairConnections" {
    Properties {

    _Color ("Color", Color) = (1,1,1,1)
    }


  SubShader{
//        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
    Cull Off
    Pass{

      //Blend SrcAlpha OneMinusSrcAlpha // Alpha blending

      CGPROGRAM
      #pragma target 4.5

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"

      #include "../../Chunks/Struct16.cginc"

          uniform int _Count;
          uniform int _NumVertsPerHair;
      uniform float3 _Color;


      StructuredBuffer<Vert> _VertBuffer;


      //uniform float4x4 worldMat;

      //A simple input struct for our pixel shader step containing a position.
      struct varyings {
          float4 pos      : SV_POSITION;
          float debug     : TEXCOORD0;
      };


      //Our vertex function simply fetches a point from the buffer corresponding to the vertex index
      //which we transform with the view-projection matrix before passing to the pixel program.
      varyings vert (uint id : SV_VertexID){

        varyings o;

        int base = id / 2;
        int alternate = id %2;
        if( base + 1 < _Count ){


            Vert v1 = _VertBuffer[base+0];
            Vert v2 = _VertBuffer[base+1];

            

                float3 pos; 
                if( alternate == 0 ){
                    pos = v1.pos;
                }else{
                    pos = v2.pos;
                }
           
            o.pos = mul (UNITY_MATRIX_VP, float4(pos,1.0f));
            o.debug = 1;

            if( v2.uv.x  == 0){
              o.debug = 0;
            }

        }
        return o;
      }




      //Pixel function returns a solid color for each point.
      float4 frag (varyings v) : COLOR {

            if( v.debug == 0 ){ discard;}
          return float4( _Color , 1 );

      }

      ENDCG

    }
  }

  Fallback Off


}
