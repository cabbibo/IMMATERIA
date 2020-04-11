Shader "Scenes/HydraScene/HydraBody"
{
    Properties {

    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture", 2D) = "white" {}
    _ColorMap ("Color Map", 2D) = "white" {}
    _CubeMap( "Cube Map" , Cube )  = "defaulttexture" {}


       _PLightMap1 ("PLightMap1", 2D) = "white" {}
       _PLightMap2 ("PLightMap2", 2D) = "white" {}
       _PLightMap3 ("PLightMap3", 2D) = "white" {}
       _PLightMap4 ("PLightMap4", 2D) = "white" {}
       _PLightMap5 ("PLightMap5", 2D) = "white" {}

    _HueStart ("HueStart", Float) = 0

  }
    SubShader
    {
        
        Pass
        {
Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off
// Lighting/ Texture Pass
Stencil
{
Ref 4
Comp always
Pass replace
ZFail keep
}

          Tags{ "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            // make fog work
            #pragma multi_compile_fogV
 #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
    


            #include "../Chunks/Struct16.cginc"

            sampler2D _MainTex;
            sampler2D _ColorMap;
      samplerCUBE _CubeMap;

            sampler2D _PLightMap1;
            sampler2D _PLightMap2;
            sampler2D _PLightMap3;
            sampler2D _PLightMap4;
            sampler2D _PLightMap5;

            float _HueStart;

            struct v2f { 
              float4 pos : SV_POSITION; 
              float3 nor : NORMAL;
              float2 uv :TEXCOORD0; 
              float3 worldPos :TEXCOORD1;
              float  kelpID :TEXCOORD3;
              float3  eye :TEXCOORD4;
              UNITY_SHADOW_COORDS(2)
            };
            float4 _Color;

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
                o.worldPos = v.pos;
                o.eye = v.pos - _WorldSpaceCameraPos;

                o.kelpID = v.debug.x;

        UNITY_TRANSFER_SHADOW(o,o.worldPos);

                return o;
            }

      float DoShadowDiscard( float3 pos , float2 uv , float3 nor ){
        float v = dot(normalize(_WorldSpaceLightPos0.xyz), normalize(nor));
        return v;//sin( uv.y * 100 + _Time.y);
      }

            fixed4 frag (v2f v) : SV_Target
            {
                // sample the texture
                fixed shadow = UNITY_SHADOW_ATTENUATION(v,v.worldPos) * .5 + .5;
                float val = -dot(normalize(_WorldSpaceLightPos0.xyz),normalize(v.nor));// -DoShadowDiscard( i.worldPos , i.uv , i.nor );

                float lookupVal =  max(min( v.uv.y * 2,( 1- v.uv.y ) ) * 1.5,0);//2 * tex2D(_MainTex,v.uv * float2(4 * saturate(min( v.uv.y * 4,( 1- v.uv.y ) )) ,.8) + float2(0,.2));
          
                float3 refl = reflect( normalize(_WorldSpaceCameraPos-v.worldPos) , v.nor);
                float reflM = dot( refl , _WorldSpaceLightPos0 );

                float4 tCol = tex2D(_MainTex, v.uv * float2( 4  ,1 ) ) * 3;
                float4 cutOff = tex2D(_MainTex,  v.uv * float2( 3 , 1  ) ) * v.uv.x * 2;
                //if( length(cutOff)  <  v.uv.x *1.2){ discard; }
                //tCol = lerp(  tCol  , cutOff  , (cutOff * cutOff* cutOff));
                float3 cCol = texCUBE(_CubeMap,refl);;// * color;


                float4 p1 = tex2D( _PLightMap1 , v.uv * 3 );
                float4 p2 = tex2D( _PLightMap2 , v.uv * 3 );
                float4 p3 = tex2D( _PLightMap3 , v.uv * 3 );
                float4 p4 = tex2D( _PLightMap4 , v.uv * 3 );
                float4 p5 = tex2D( _PLightMap5 , v.uv * 3 );

                float3 fNor = v.nor;
                float m = dot(_WorldSpaceLightPos0.xyz , fNor);

                float fern = dot( _WorldSpaceLightPos0, normalize(fNor) );
 
                m = 1-1.5*fern;//1-pow(fern,.7);//*fern*fern;//pow( fern * fern, 1);
                //m = saturate( 1-m );
                m = 5 * m;

               // m *= (1- .8*UNITY_SHADOW_ATTENUATION(v,v.worldPos));

                float4 fLCol = float4(1,0,0,1);
                if( m < 1 ){
                    fLCol = lerp( p1 , p2 , saturate(m) );
                }else if( m >= 1 && m < 2){
                    fLCol = lerp( p2 , p3 , m-1 );
                }else if( m >= 2 && m < 3){
                    fLCol = lerp( p3 , p4 , m-2 );
                }else if( m >= 3 && m < 4){
                    fLCol = lerp( p4 , p5 , m-3 );
                }else if( m >= 4 && m < 5){
                    fLCol = lerp( p5 , p5 , m-4 );
                }else{
                    fLCol = p5;
                }

               // if( ( lookupVal + 1.3) - 1.2*length( tCol ) < .5 ){ discard;}
               // fixed4 col = float4( cCol , 1 ) * 2 * shadow * v.uv.x * 1.4 * tex2D(_ColorMap , float2( -length(tCol) * .2 * v.uv.x * v.uv.x*v.uv.x* .5 - val * .1  + sin( v.kelpID) * .02 +  _HueStart, 0) );// * saturate(20*-val);//* 20-10;//*tCol* lookupVal*4;//* 10 - 1;
                
                fixed4 col =  tex2D(_ColorMap,float2(v.uv.x , 0));
                  col*= fLCol;//tex2D(_MainTex,v.uv * 5);
                 // col*=shadow;
                return col;
            }

            ENDCG
        }



           // SHADOW PASS

    Pass
    {
      Tags{ "LightMode" = "ShadowCaster" }


      Fog{ Mode Off }
      ZWrite On
      ZTest LEqual
      Cull Off
      Offset 1, 1
      CGPROGRAM



      float DoShadowDiscard( float3 pos , float2 uv ){
         return 1;//float lookupVal =  max(min( uv.y * 2,( 1- uv.y ) ) * 1.5,0);//2 * tex2D(_MainTex,uv * float2(4 * saturate(min( uv.y * 4,( 1- uv.y ) )) ,.8) + float2(0,.2));
         // float4 tCol = tex2D(_MainTex, uv *   float2( 6,(lookupVal)* 1 ));
         // if( ( lookupVal + 1.3) - 1.2*length( tCol ) < .5 ){ return 0;}else{return 1;}
      }

      #pragma target 4.5
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_shadowcaster
      #pragma fragmentoption ARB_precision_hint_fastest

      #include "UnityCG.cginc"
      sampler2D _MainTex;


      #include "../Chunks/ShadowDiscardFunction.cginc"
      ENDCG
    }




               // SHADOW PASS

    Pass
    {

// Outline Pass
Cull OFF
ZWrite OFF
ZTest ON
Stencil
{
Ref 4
Comp notequal
Fail keep
Pass replace
}
      
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            // make fog work
            #pragma multi_compile_fogV
 #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
    


            #include "../Chunks/Struct16.cginc"


            struct v2f { 
              float4 pos : SV_POSITION; 
            };
            float4 _Color;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;

        
                Vert v = _VertBuffer[_TriBuffer[vid]];
                float3 fPos = v.pos + v.nor * .004;
                o.pos = mul (UNITY_MATRIX_VP, float4(fPos,1.0f));


                return o;
            }

            fixed4 frag (v2f v) : SV_Target
            {
              
                fixed4 col = 1;
                return col;
            }

            ENDCG
        }

    
  
  
  
  }








}