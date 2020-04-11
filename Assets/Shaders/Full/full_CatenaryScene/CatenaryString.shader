Shader "Scenes/Catenary/String"
{
    Properties {

    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture", 2D) = "white" {}
    _ColorMap ("Color Map", 2D) = "white" {}
    _HueStart ("HueStart", Float) = 0

    _CubeMap( "Cube Map" , Cube )  = "defaulttexture" {}

  }
    SubShader
    {
        
        Pass
        {
Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off

          Tags{ "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5

      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
    


            #include "../Chunks/Struct16.cginc"

            sampler2D _MainTex;
            sampler2D _ColorMap;
            sampler2D _AudioMap;

      samplerCUBE _CubeMap;


            struct v2f { 
              float4 pos : SV_POSITION; 
              float3 nor : NORMAL;
              float2 uv :TEXCOORD0; 
              float3 worldPos :TEXCOORD1;
              float3 vel :TEXCOORD5;
              float2 debug :TEXCOORD3;
              float id :TEXCOORD4;
              UNITY_SHADOW_COORDS(2)
            };
            float4 _Color;
            float _HueStart;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;

        UNITY_INITIALIZE_OUTPUT(v2f, o);
                Vert v = _VertBuffer[_TriBuffer[vid]];
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1.0f));


                o.nor = v.nor;
                o.uv = v.uv;
                o.vel = v.vel;
                o.worldPos = v.pos;
                o.debug = v.debug;
                o.id = vid / 12;


                return o;
            }


            fixed4 frag (v2f v) : SV_Target
            {
                float val = -dot(normalize(_WorldSpaceLightPos0.xyz),normalize(v.nor));// -DoShadowDiscard( i.worldPos , i.uv , i.nor );

                 float4 tCol = tex2D(_MainTex, v.uv );
                 float vL = length(v.uv-.5) ;
                 if( length( tCol ) < .1){ discard; }

                float3 refl = reflect( normalize(_WorldSpaceCameraPos-v.worldPos) , v.nor);
                 //if( vL > .4 ){ discard; }
                 float4 aCol = tex2D(_AudioMap, float2( abs(sin(v.uv.x * 10+ _Time.y * .3 + v.debug.y) * .2 )  , 0) );
                 float4 cCol = tex2D(_ColorMap,v.uv.x + sin(v.debug.y) - _Time.y * .2  );

                 float3 cubeCol = texCUBE(_CubeMap , refl);
                fixed4 col = 1;
                col.xyz =  cubeCol;//cCol;//match;//1;//aCol * aCol * 2 * (normalize(v.vel) *  .5 + .5) * clamp(length(v.vel) * 30, 0 ,1);//match;//saturate(match+.5)*1.1*tCol*tex2D(_ColorMap , float2( length( tCol) * .1 + sin(vL*10 + length(tCol)*10 - _Time.y*10  * sin(v.id/300)) * .04 + sin(v.id/1000) * .2+  _HueStart   + match *.2, 0) );//saturate(((_Time-v.debug.y) * 1 )) *  tex2D(_ColorMap , float2( length( tCol) * length( tCol ) * .1  + _HueStart , 0) )  * tCol* tCol;//* 20-10;//*tCol* lookupVal*4;//* 10 - 1;
                //if( vL > .3){ col = 0;}
                  //if( v.debug.x > .5 ){ col =float4(1,0,0,1);}
               col.xyz =  aCol * (normalize(v.vel) * .5 + .5);//cubeCol;//cCol;//match;//1;//aCol * aCol * 2 * (normalize(v.vel) *  .5 + .5) * clamp(length(v.vel) * 30, 0 ,1);//match;//saturate(match+.5)*1.1*tCol*tex2D(_ColorMap , float2( length( tCol) * .1 + sin(vL*10 + length(tCol)*10 - _Time.y*10  * sin(v.id/300)) * .04 + sin(v.id/1000) * .2+  _HueStart   + match *.2, 0) );//saturate(((_Time-v.debug.y) * 1 )) *  tex2D(_ColorMap , float2( length( tCol) * length( tCol ) * .1  + _HueStart , 0) )  * tCol* tCol;//* 20-10;//*tCol* lookupVal*4;//* 10 - 1;
                 return col;
            }

            ENDCG
        

        }

    




    }



    Fallback "Diffuse"
}