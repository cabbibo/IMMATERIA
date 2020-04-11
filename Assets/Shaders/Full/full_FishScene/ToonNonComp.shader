// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "toonNonCompute"
{
    
    
    Properties {

       _ColorMap ("ColorMap", 2D) = "white" {}

        _Saturation("_Saturation",float) = .3
        _Brightness("_Brightness",float) = .1
        _OutlineWidth("_OutlineWidth",float) = .01
        _OutlineHue("_OutlineHue",float) = .1
        _HueSize("_HueSize",float) = .1
        _HueBase("_HueBase",float) = .1
    
    }



    CGINCLUDE
        #pragma vertex vert
        #pragma fragment frag
        #pragma target 4.5
        #include "UnityCG.cginc"

        struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

    ENDCG
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off
        Pass
        {

            Stencil
            {
                Ref 7
                Comp always
                Pass replace
                ZFail keep
            }

            CGPROGRAM
       

            #pragma multi_compile_fwdbase
            #pragma fragmentoption ARB_precision_hint_fastest

            #include "AutoLight.cginc"

           sampler2D _ColorMap;

            float _ColorStart;
            float _ColorRandomSize;
            float _Saturation;
            float _Brightness;
            float _HueBase;;
            float _HueSize;

            
            struct v2f { 
                float4 pos : SV_POSITION; 
                float3 nor : NORMAL; 
                float3 world : TEXCOORD1; 
                float3 worldNor : TEXCOORD2; 
                float2 uv  : TEXCOORD3; 
                LIGHTING_COORDS(5,6)
            };

            v2f vert ( appdata v )
            {
                v2f o;
                o.pos = UnityObjectToClipPos (float4(v.vertex.xyz,1.0f));
                o.uv = v.uv;
                
                o.nor  = v.normal;
                o.worldNor =  mul( unity_ObjectToWorld , float4(v.normal , 0 )).xyz;
                o.world = mul( unity_ObjectToWorld , v.vertex).xyz;
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag (v2f v) : SV_Target
            {


 

                float3 fNor = normalize(v.worldNor);
                float m = dot(_WorldSpaceLightPos0.xyz , fNor);

             

                float atten = LIGHT_ATTENUATION(v);

                float lightVal = atten * m;
                lightVal = floor(lightVal * 5)/5;
                float4 tCol = tex2D( _ColorMap , float2(  lightVal * _HueSize  + _HueBase, 0) );
               
                float3 fCol= tCol * lightVal * 2;
                fixed4 col = float4(fCol,1);
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

      #pragma multi_compile_shadowcaster
      #pragma fragmentoption ARB_precision_hint_fastest 

      #include "../../Chunks/ShadowCasterPos.cginc"

      struct v2f {
        V2F_SHADOW_CASTER;
        float3 nor : NORMAL;
      };


      v2f vert(appdata v)
      {
        v2f o;        
        o.nor = normalize( v.normal);
        float3 world = mul( unity_ObjectToWorld , v.vertex).xyz;
        o.nor  = v.normal;//mul( unity_ObjectToWorld , float4(v.normal , 0 )).xyz;
        float4 position = ShadowCasterPos(v.vertex, normalize(o.nor));
        o.pos = UnityApplyLinearShadowBias(position);
        return o;
      }

      float4 frag(v2f i) : COLOR
      {
        SHADOW_CASTER_FRAGMENT(i)
      }
      ENDCG
    }


Pass
    {

// Outline Pass
Cull OFF
ZWrite OFF
ZTest ON
Stencil
{
Ref 7
Comp notequal
Fail keep
Pass replace
}
      
            CGPROGRAM
            // make fog work
            #pragma multi_compile_fogV
             #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

      #include "AutoLight.cginc"
    


            struct v2f { 
              float4 pos : SV_POSITION; 
            };
            float4 _Color;
            float _OutlineWidth;
            float _OutlineHue;
            v2f vert ( appdata v )
            {
                v2f o;

                float3 fPos = v.vertex + v.normal * _OutlineWidth;
                o.pos = UnityObjectToClipPos (float4(fPos,1.0f));


                return o;
            }

            sampler2D _ColorMap;
            fixed4 frag (v2f v) : SV_Target
            {
              
                fixed4 col = tex2D(_ColorMap, float2( _OutlineHue,0));
                return col;
            }

            ENDCG
        }

    
  

  
  
    }

FallBack "Diffuse"
}