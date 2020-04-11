Shader "Scenes/SpacePup/Body2"
{
    Properties {

       _ColorMap ("ColorMap", 2D) = "white" {}
       _TextureMap ("TextureMap", 2D) = "white" {}
       _PLightMap ("PLightMap", 2D) = "white" {}

    _CubeMap( "Cube Map" , Cube )  = "defaulttexture" {}
    _HueStart( "Hue Start" , float )  = 0
    
    }

    SubShader
    {
        Tags { "RenderType"="Opaque"}
        LOD 100

        Cull Off
        Pass
        {

          // Lighting/ Texture Pass
Stencil
{
Ref 5
Comp always
Pass replace
ZFail keep
}

          Tags{  "LightMode" = "ForwardBase"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5


            #pragma multi_compile_fwdbase
            #pragma fragmentoption ARB_precision_hint_fastest

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"


            struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 offset;
      float4 debug;
      float3 connections[16];
    };


            struct v2f { 
                float4 pos : SV_POSITION; 
                float3 nor : NORMAL; 
                float debug : TEXCOORD0; 
                float3 eye : TEXCOORD1; 
                float2 uv : TEXCOORD3; 
                float3 world : TEXCOORD2; 
                float3 vel : TEXCOORD7; 
                float4 screenPos : TEXCOORD4; 

// in v2f struct;
LIGHTING_COORDS(5,6)
            };

            float4 _Color;
            float _HueStart;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            sampler2D _ColorMap;
            sampler2D _TextureMap;

            sampler2D _AudioMap;

            sampler2D _PLightMap;

      samplerCUBE _CubeMap;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;
                Vert v = _VertBuffer[_TriBuffer[vid]];
            
            
                o.world = v.pos;
                o.uv = v.uv;
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1));
                o.nor = normalize(-v.nor);//normalize(cross(v0.pos - v1.pos , v0.pos - v2.pos ));
                o.debug = v.debug;
                o.eye = v.pos - _WorldSpaceCameraPos;
                o.vel =v.vel;
                o.screenPos = ComputeScreenPos(float4(v.pos,1));

                // in vert shader;
TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag (v2f v) : SV_Target
            {

                float4 t1 = tex2D(_TextureMap , v.world.zy * .1 ) * abs(v.nor.x);
                float4 t2 = tex2D(_TextureMap , v.world.xz * .1 ) * abs(v.nor.y);
                float4 t3 = tex2D(_TextureMap , v.world.xy * .1 ) * abs(v.nor.z);

                float4 t = tex2D(_TextureMap , v.uv * 4 );


               //float4 p1 = tex2D( _PLightMap1 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
               //float4 p2 = tex2D( _PLightMap2 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
               //float4 p3 = tex2D( _PLightMap3 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
               //float4 p4 = tex2D( _PLightMap4 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
               //float4 p5 = tex2D( _PLightMap5 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
           
                 float4 tFinal = t1 + t2 + t3;


                float3 fNor = v.nor;// + .9*float3( t1.x , t2.x, t3.x);
                fNor = normalize( fNor );

                float3 refl = reflect( normalize( v.eye ), fNor );
                float m = dot(_WorldSpaceLightPos0.xyz , fNor);

                float fern = dot( normalize( v.eye ), normalize(fNor) );
 

//in frag shader;
float atten = LIGHT_ATTENUATION(v);
                //m = 1-pow(-fern,.7);//*fern*fern;//pow( fern * fern, 1);
                //m = saturate( 1-m );
 float4 p = tex2D( _PLightMap , v.uv.yx * float2(1,5) * 3);


                m = 1-((1-m)*atten);

                float baseM = m;
                m *= 3;

                float4 fLCol = float4(1,0,0,0);


                float4 weights = 0;
                if( m < 1 ){
                   weights = float4(1-m , m , 0, 0);//lerp( p.x , p.y , m );
                }else if( m >= 1 && m < 2){
                    weights = float4(0,1-(m-1) , (m-1) ,  0);
                }else if( m >= 2 && m < 3){
                    weights = float4(0,0,1-(m-2) , (m-2) );
                }else{
                  weights = float4(0,0,0 , 1);
                }



                fLCol = p.x * weights.x;
                fLCol += p.y * weights.y;
                fLCol += p.z * weights.z;
                fLCol += p.w * weights.w;
                fLCol = 1-fLCol;





                float4 s = texCUBE( _CubeMap , refl );
                float4 s2 = tex2D( _ColorMap , float2(m* .1+_HueStart, 0) );
                

                m = dot(_WorldSpaceLightPos0.xyz , fNor);
                float4 aCol = tex2D(_AudioMap , float2( abs(m) * .3 , 0));

                float fVal = (fLCol * .7 + .3) * s2;

                float4 fCol =  -m * float4(1,0,0,1);//fLCol *length(s)*.5 * s2;//tex2D(_ColorMap , float2(saturate(fVal * .2 + .4 - .1*v.debug),0)) * (1-fVal) * s;//(v.debug * .4+.3);
               
                //fCol.xyz = fNor * .5 + .5;//s*fLCol;//saturate( -fCol );
                // sample the texture
                fixed4 col =fCol;//afCol;//fCol;//(fLCol * .7 + .3) * s2;//(fLCol.x  * .8 + .2) * s2 * s;//float4( fNor * .5 + .5 , 1);//tex2D(_MainTex, i.uv);
                

                float3 velCol;
                if( length( v.vel ) > .0000001){
                  velCol = (normalize(v.vel)  * .5 + .5);
                }else{
                  velCol = .5;
                }


                col = .3 + 1* tex2D(_ColorMap,float2(baseM * .13  +_HueStart, 0));
              
                col.xyz =fLCol * s * s * 2;//col *  s * (1-baseM);// 1-saturate(saturate(aCol)* s * velCol);
                  
                  col.xyz = normalize(v.vel) * .5 + .5;

                //col = lerp( col ,fCol , length(col) * length(col));
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
  

      #include "../../Chunks/ShadowCasterPos.cginc"


            struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 offset;
      float4 debug;
      float3 connections[16];
    };



      StructuredBuffer<Vert> _VertBuffer;
      StructuredBuffer<int> _TriBuffer;

      struct v2f {
        V2F_SHADOW_CASTER;
        float3 nor : NORMAL;
      };


      v2f vert(appdata_base input, uint id : SV_VertexID)
      {
        v2f o;
        Vert v = _VertBuffer[_TriBuffer[id]];
        o.nor = normalize( -v.nor);
        float4 position = ShadowCasterPos(v.pos, normalize(-v.nor));
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
Ref 5
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
    


               struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 offset;
      float4 debug;
      float3 connections[16];
    };


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
                float3 fPos = v.pos;// + v.nor * .1;
                o.pos = mul (UNITY_MATRIX_VP, float4(fPos,1.0f));


                return o;
            }

            sampler2D _ColorMap;
            fixed4 frag (v2f v) : SV_Target
            {
              
                fixed4 col = 0;//.5 + .8 * tex2D(_ColorMap, float2( .95,0));//1;//tex2D(_ColorMap, float2( .5,0));
                return col;
            }

            ENDCG
        }

    
  

  
  
  
  }


FallBack "Diffuse"
}