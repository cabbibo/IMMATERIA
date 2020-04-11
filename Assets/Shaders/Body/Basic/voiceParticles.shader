Shader "Scenes/mouth/shadowMouth"
{
    Properties {

    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture", 2D) = "white" {}
    _ColorMap ("Color Map", 2D) = "white" {}

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
            // make fog work
            #pragma multi_compile_fogV
 #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
    


            #include "../Chunks/Struct16.cginc"
            #include "../Chunks/hsv.cginc"

            sampler2D _MainTex;
            sampler2D _ColorMap;

            struct v2f { 
              float4 pos : SV_POSITION; 
              float3 nor : NORMAL;
              float2 uv :TEXCOORD0; 
              float3 worldPos :TEXCOORD1;
              float2 debug : TEXCOORD3;
              float3 eye : TEXCOORD4;
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
                o.debug = v.debug;
                o.eye = v.pos - _WorldSpaceCameraPos;


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

                

                float lookupVal =  length( v.uv - .5 );//max( ) * 1.5,0);//2 * tex2D(_MainTex,v.uv * float2(4 * saturate(min( v.uv.y * 4,( 1- v.uv.y ) )) ,.8) + float2(0,.2));
                if( lookupVal > .5){discard;}



                float3 col1 = hsv( sin(v.debug.y* 100 + .3) + .1 * sin( v.debug.x) + lookupVal * .1 + dot( normalize( v.eye), v.nor) * .1, 1 ,1 );
                //float4 tCol = tex2D(_MainTex, v.uv *   float2( 6,(lookupVal)* 1 ));
                //if( ( lookupVal + 1.3) - 1.2*length( tCol ) < .5 ){ discard;}
                fixed4 col = float4(col1,1);

                col *= shadow;// tex2D(_ColorMap , float2( length(tCol) * .6 + (1-shadow  * .05)+ .0 + lookupVal* lookupVal * .1 , 0) );//* 20-10;//*tCol* lookupVal*4;//* 10 - 1;
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

      #pragma target 4.5
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_shadowcaster
      #pragma fragmentoption ARB_precision_hint_fastest

      #include "UnityCG.cginc"
      sampler2D _MainTex;

      float DoShadowDiscard( float3 pos , float2 uv ){
         return   1-length( uv - .5 );//max( ) * 1.5,0);//2 * tex2D(_MainTex,v.uv * float2(4 * saturate(min( v.uv.y * 4,( 1- v.uv.y ) )) ,.8) + float2(0,.2));
               
      }

      #include "../Chunks/ShadowDiscardFunction.cginc"
      ENDCG
    }
  
    }
}
