Shader "Scenes/FishScene/Ribbons1"
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



          Tags{  "LightMode" = "ForwardBase"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5


            #pragma multi_compile_fwdbase
            #pragma fragmentoption ARB_precision_hint_fastest

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "../../Chunks/noise.cginc"
            #include "../../Chunks/hsv.cginc"


     struct Vert{
    float3 pos;
    float3 vel;
    float3 nor;
    float3 tangent;
    float2 uv;
    float2 debug;
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
                //o.uv = v.uv;

                 float offset = floor(hash(v.debug.x) * 6) /6;
                o.uv = v.uv * float2(1,1./6.) + float2(-.1,offset);
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

                float4 t = tex2D(_TextureMap , v.uv  );

                if( t.a < .3 ){ discard; }

                float3 fNor = v.nor;// + .9*float3( t1.x , t2.x, t3.x);
                fNor = normalize( fNor );

                float3 refl = reflect( normalize( v.eye ), fNor );
                float m = dot(_WorldSpaceLightPos0.xyz , fNor);

                float fern = dot( normalize( v.eye ), normalize(fNor) );
 

//in frag shader;
float atten = LIGHT_ATTENUATION(v);
                //m = 1-pow(-fern,.7);//*fern*fern;//pow( fern * fern, 1);
                //m = saturate( 1-m );
 float4 p = tex2D( _PLightMap , v.uv.yx * float2(1,5));


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




                float3 velCol;
                if( length( v.vel ) > .0000001){
                  velCol = normalize(v.vel);
                }else{
                  velCol = .5;
                }
                float4 s = texCUBE( _CubeMap , reflect( v.eye , velCol ) );
                float4 s2 = tex2D( _ColorMap , float2(m* .1+_HueStart, 0) );
                

                m = dot(_WorldSpaceLightPos0.xyz , fNor);
                float4 aCol = tex2D(_AudioMap , float2( t.y * .1 +  v.uv.x  * .1 + sin( v.debug.x), 0));

                float fVal = (fLCol * .7 + .3) * s2;

                float4 fCol =  -m * float4(1,0,0,1);//fLCol *length(s)*.5 * s2;//tex2D(_ColorMap , float2(saturate(fVal * .2 + .4 - .1*v.debug),0)) * (1-fVal) * s;//(v.debug * .4+.3);
               
                //fCol.xyz = fNor * .5 + .5;//s*fLCol;//saturate( -fCol );
                // sample the texture
                fixed4 col =fCol;//afCol;//fCol;//(fLCol * .7 + .3) * s2;//(fLCol.x  * .8 + .2) * s2 * s;//float4( fNor * .5 + .5 , 1);//tex2D(_MainTex, i.uv);
            


                col = tex2D(_ColorMap,float2(v.uv.x * .2 + (sin(v.debug.x) + 1 ) * .4 + t.y * .2, 0));
                

                /*


                SECTION FOR COLIN TO COMMENT / UNCOMMENT

                */

                // Multiplicative audio noise!
                //col.xyz =  col * s * s * 6 * aCol;


                // subtractive
                //col.xyz =  col * s * s * 5 - aCol;

                // additive
                //col.xyz =  col * s * s * 2 + aCol;

                // non reactive
                //col.xyz =  col * s * s * 3;

                // mega multiplicative
                //col.xyz =  saturate(col * s * s * 30 *aCol* aCol);

                // reflective audio
                //col.xyz = aCol * aCol * s * s * 5;


                // just audio
                //col.xyz = aCol*aCol;


                // additive shiny
                //col.xyz = (col + aCol) * s * s * s * 4;

                // subtractive shiny
                col.xyz = (col - aCol * aCol * 1) * s * s * s * 8;


                // - aCol * 2;//t;//fLCol;//fCol;//atten;// s*s;//5*s * s * aCol * t.y;
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

            #include "../../Chunks/hash.cginc"

  struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };

  StructuredBuffer<Vert> _VertBuffer;
  StructuredBuffer<int> _TriBuffer;

      #include "../../Chunks/ShadowCasterPos.cginc"
sampler2D _MainTex;
  struct v2f {
        V2F_SHADOW_CASTER;
        float2 uv : TEXCOORD1;
        float2 debug : TEXCOORD2;
      };


      v2f vert( uint id : SV_VertexID)
      {

        Vert v = _VertBuffer[_TriBuffer[id]];
        
        float3 fPos   = v.pos;
        float3 fNor   = v.nor;
        float2 fUV    = v.uv;
        float2 debug  = v.debug;

        v2f o;
       
        float offset = floor(hash(debug.x) * 6) /6;
               o.uv =  fUV * float2(1,1./6.) + float2(-.1,offset);
        //o.uv = fUV.xy  -float2(0.1,0);// *float2(1./6.,1);;
        float4 position = ShadowCasterPos(v.pos, -v.tan);
        o.pos = UnityApplyLinearShadowBias(position);
        o.debug = debug;
        return o;
      }

      float4 frag(v2f i) : COLOR
      {
        float4 col = tex2D(_MainTex,i.uv);

        //if( i.debug.y < .3 ){ discard; }
        if( col.a < .3){discard;}
        SHADOW_CASTER_FRAGMENT(i)
      }
      ENDCG
    }
        
}

FallBack "Diffuse"
}