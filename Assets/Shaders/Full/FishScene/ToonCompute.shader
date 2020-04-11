Shader "toonCompute"
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
        #include "../../Chunks/Struct16.cginc"



        StructuredBuffer<Vert> _VertBuffer;
        StructuredBuffer<int> _TriBuffer;
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
                Ref 9
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
                float2 uv  : TEXCOORD2; 
                float2 debug  : TEXCOORD3; 
                half3 tang : TEXCOORD4; 
                LIGHTING_COORDS(5,6)
            };

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;
                Vert v = _VertBuffer[_TriBuffer[vid]];
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1.0f));
                o.uv = v.uv;
                o.nor = v.nor;
                o.world = v.pos;
                o.debug = v.debug;
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag (v2f v) : SV_Target
            {


 

                float3 fNor = normalize(v.nor);
                float m = dot(_WorldSpaceLightPos0.xyz , fNor);

             

                float atten = LIGHT_ATTENUATION(v);

                float lightVal = atten * m * v.uv.x*1;
                lightVal = floor(lightVal * 5)/5;
                float4 tCol = tex2D( _ColorMap , float2(  _HueSize  + lightVal, 0) );
               
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


      v2f vert(appdata_base input, uint id : SV_VertexID)
      {
        v2f o;
        Vert v = _VertBuffer[_TriBuffer[id]];
        o.nor = normalize( v.nor);
        float4 position = ShadowCasterPos(v.pos, normalize(v.nor));
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
            Ref 9
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
            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;

        
                Vert v = _VertBuffer[_TriBuffer[vid]];
                float3 fPos = v.pos + v.nor * _OutlineWidth;
                o.pos = mul (UNITY_MATRIX_VP, float4(fPos,1.0f));


                return o;
            }

            sampler2D _ColorMap;
            fixed4 frag (v2f v) : SV_Target
            {
              
                fixed4 col = tex2D(_ColorMap, float2( _OutlineHue,0));
                col = 0;
                return col;
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
            Ref 9
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
            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;

        
                Vert v = _VertBuffer[_TriBuffer[vid]];
                float3 fPos = v.pos + v.nor * _OutlineWidth*2;
                o.pos = mul (UNITY_MATRIX_VP, float4(fPos,1.0f));


                return o;
            }

            sampler2D _ColorMap;
            fixed4 frag (v2f v) : SV_Target
            {
              
                fixed4 col = tex2D(_ColorMap, float2( _OutlineHue + .5,0));
                return col;
            }

            ENDCG
        }

    
  

  
  
  
  
    }


   

FallBack "Diffuse"
}