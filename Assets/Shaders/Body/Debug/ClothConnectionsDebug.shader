Shader "IMMAT/Debug/ClothConnections" {
    Properties {

    _Color ("Color", Color) = (1,1,1,1)
    _Size ("_Size", float) = .01
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


    struct Connection{
        float id1;
        float id2;
        float len;
        float stiffness;
    };

      StructuredBuffer<Vert> _VertBuffer;
      StructuredBuffer<Connection> _ConnectionBuffer;

float _Size;
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

        int base = id / 6;
        int alternate = id %6;


        
        float3 pos = 0;
        float debug = base % 4;
        if( base  < _Count ){

            Connection c = _ConnectionBuffer[ base ];

            if( c.id1 >= 0 && c.id2 >= 0 ){
                
                Vert v1 = _VertBuffer[int(c.id1)];
                Vert v2 = _VertBuffer[int(c.id2)];
                
                  float3 dif = v2.pos - v1.pos;
                float3 left = normalize( cross(dif,UNITY_MATRIX_V[2].xyz));
                left *= _Size;
                
                float2 uv = float2(0,0);

                float3 fPos = v1.pos;


                if( alternate == 0 ){ fPos = fPos - left; uv = float2(0,0); }
                if( alternate == 1 ){ fPos =  fPos + left ; uv = float2(1,0); }
                if( alternate == 2 ){ fPos =  fPos + left + dif ; uv = float2(1,1); }
                if( alternate == 3 ){ fPos = fPos - left; uv = float2(0,0); }
                if( alternate == 4 ){ fPos =  fPos + left + dif ; uv = float2(1,1); }
                if( alternate == 5 ){ fPos = fPos - left + dif ; uv = float2(0,1); }

                pos = fPos;
           

            }

        }

        o.pos = mul (UNITY_MATRIX_VP, float4(pos,1.0f));
        o.debug = debug;
        return o;
      }




      //Pixel function returns a solid color for each point.
      float4 frag (varyings v) : COLOR {

            
        float3 col = _Color;

        if( v.debug  < 2.5 ){ col = float3(0,0,1);}
        if( v.debug  <1.5 ){ col = float3(0,1,0);}
        if( v.debug  < .5 ){ col = float3(1,0,0);}
          return float4(col , 1 );

      }

      ENDCG

    }
  }

  Fallback Off


}
