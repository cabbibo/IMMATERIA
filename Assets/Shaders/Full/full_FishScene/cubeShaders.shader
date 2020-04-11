Shader "Scenes/FishScene/Coral"
{

  Properties {
  
        // This is how many steps the trace will take.
        // Keep in mind that increasing this will increase
        // Cost
    _NumberSteps( "Number Steps", Int ) = 4

    // Total Depth of the trace. Deeper means more parallax
    // but also less precision per step
    _TotalDepth( "Total Depth", Float ) = 0.16


    _NoiseSize( "Noise Size", Float ) = 10
    _NoiseSpeed( "Noise Speed", Float ) = 10
    _HueSize( "Hue Size", Float ) = .3
    _BaseHue( "Base Hue", Float ) = .3

    _MainTex( "Main Tex" , 2D ) = "white" {}
    _ColorMap( "Color Map" , 2D ) = "white" {}





  }

  SubShader {


        Cull Back
        ZWrite On

        Tags { "Queue" = "Geometry-100" }
    Pass {

      CGPROGRAM

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"


      uniform int _NumberSteps;
      uniform float _TotalDepth;
      uniform float _NoiseSize;
      uniform float _NoiseSpeed;
      uniform float _HueSize;
      uniform float _BaseHue;
      uniform float _Cutoff;


      uniform sampler2D _AudioMap;
      uniform sampler2D _MainTex;
      uniform sampler2D _ColorMap;

      uniform float _ScaleX;
      uniform float _ScaleY;

      uniform float _CurrTexture;

      struct VertexIn{
         float4 position  : POSITION; 
         float3 normal    : NORMAL; 
         float4 texcoord  : TEXCOORD0; 
         float4 tangent   : TANGENT;
      };


      struct VertexOut {
          float4 pos        : POSITION; 
          float3 normal     : NORMAL; 
          float4 uv         : TEXCOORD0; 
          float3 ro         : TEXCOORD1;
          float3 rd         : TEXCOORD2;
      };


            float3 hsv(float h, float s, float v){
        return lerp( float3( 1.0,1,1 ), clamp(( abs( frac(h + float3( 3.0, 2.0, 1.0 ) / 3.0 )
                             * 6.0 - 3.0 ) - 1.0 ), 0.0, 1.0 ), s ) * v;
      }

       //From IQ shaders
      float hash( float n )
      {
          return frac(sin(n)*43758.5453);
      }

      float noise( float3 x )
      {
          // The noise function returns a value in the range -1.0f -> 1.0f
          x.z += .2 * _Time.y;

          float3 p = floor(x);
          float3 f = frac(x);

          f       = f*f*(3.0-2.0*f);
          float n = p.x + p.y*57.0 + 113.0*p.z;

          return lerp(lerp(lerp( hash(n+0.0), hash(n+1.0),f.x),
                         lerp( hash(n+57.0), hash(n+58.0),f.x),f.y),
                     lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
                         lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
      }


float tri( float x ){ 
              return abs( frac(x) - .5 );
            }

            float3 tri3( float3 p ){
             
              return float3( 
                  tri( p.z + tri( p.y * 1. ) ), 
                  tri( p.z + tri( p.x * 1. ) ), 
                  tri( p.y + tri( p.x * 1. ) )
              );

            }
                                             
            float triNoise3D( float3 p, float spd , float time){
              
              float z  = 1.4;
                float rz =  0.;
              float3  bp =   p;

                for( float i = 0.; i <= 3.; i++ ){
               
                float3 dg = tri3( bp * 2. );
                p += ( dg + time * .1 * spd );

                bp *= 1.8;
                    z  *= 1.5;
                    p  *= 1.2; 
                  
                float t = tri( p.z + tri( p.x + tri( p.y )));
                rz += t / z;
                bp += 0.14;

                }

                return rz;

            }

      float getFogVal( float3 pos ){

        pos *= _NoiseSize * .3;

        float patternVal = 1;//sin( length( pos )  * _PatternSize )+1;
        float noiseVal = triNoise3D( pos * .1 , 1 , _Time.y * _NoiseSpeed )+1.6 + triNoise3D( pos * .5 , 1 , _Time.y* _NoiseSpeed ) * .5 + triNoise3D( pos * 2, 1 , _Time.y* _NoiseSpeed ) * .1;
        return patternVal * noiseVal;
      }
      

      /*float getFogVal( float3 pos ){
        pos *= _NoiseSize;
        float oct1 = noise( pos * 3 + _Time.y * .3 * _NoiseSpeed );
        float oct2 =.5 * noise( pos * 8 + _Time.y * .2 * _NoiseSpeed ) ;
        float oct3 =.25 * noise( pos * 20 + _Time.y * .1 *_NoiseSpeed);
        float v =  oct1 + oct2 + oct3;
        return  v * v * v * .4 ;
      }*/
      
float sdBox( float3 p, float3 b )
{
  float3 d = abs(p) - b;
  return length(max(d,0.0))
         + min(max(d.x,max(d.y,d.z)),0.0); // remove this line for an only partially signed sdf 
}


      
      VertexOut vert(VertexIn v) {
        
        VertexOut o;

        o.normal = v.normal;

        o.uv = v.texcoord;
       
  
        // Getting the position for actual position
        o.pos = UnityObjectToClipPos(  v.position );
     
        float3 mPos = mul( unity_ObjectToWorld , v.position );

        // The ray origin will be right where the position is of the surface
        o.ro = mPos;

        o.normal =UnityObjectToWorldNormal(v.normal);// mul( float4( v.normal, 0.0 ),unity_ObjectToWorld ).xyz;//mul( unity_ObjectToWorld , float4(v.normal,0)).xyz;


       // float3 camPos = mul( unity_WorldToObject , float4( _WorldSpaceCameraPos , 1. )).xyz;

        // the ray direction will use the position of the camera in local space, and 
        // draw a ray from the camera to the position shooting a ray through that point
        o.rd = -normalize(_WorldSpaceCameraPos - mPos);//normalize( v.position.xyz - camPos );

        return o;

      }


float map(float3 p){
       float3 newPos = mul(unity_WorldToObject, float4( p ,1)).xyz;
      float h = sdBox( newPos , float3(.44,.44,.44)) + .005*noise(p*100) + .02 * noise(p*10) + .1 * noise(p);
      return h;
}



struct fragmentOutput {
        float4 color : SV_Target;
        float zvalue : SV_Depth;
      };
      // Fragment Shader
      fragmentOutput frag(VertexOut v) : COLOR {

                // Ray origin 
        float3 ro           = v.ro;

        // Ray direction
        float3 rd           = v.rd;       

        // Our color starts off at zero,   
        float3 col = float3( 1.0 , 0.0 , 0.0 );

        float3 p;


        bool hit = false;

        float d = 0;
        float h = .05  * 2;

        float3 nor = v.normal;

        for( int i = 0; i < 4; i++ ){

          //  if ( hit == false ){
          float stepVal = float(i)/_NumberSteps;


         

          
            // We get out position by adding the ray direction to the ray origin
            // Keep in mind thtat because the ray direction is normalized, the depth
            // into the step will be defined by our number of steps and total depth
          p = v.ro + v.rd * d;

          float3 newPos = mul(unity_WorldToObject, float4( p ,1)).xyz;
          h =noise( p * 10) + noise(p);//map(p);
          
          d += .1 + h; //h * 4;
          

          if( h < 1 ){
            hit = true;
            break;
          }

         


        }

        nor = normalize(float3(
                        map(p+float3(.001,0,0))-map(p-float3(.001,0,0)),
                        map(p+float3(0,0.001,0))-map(p-float3(0,.001,0)),
                        map(p+float3(0,0,0.001))-map(p-float3(0,0,.001))));

        nor = v.normal;// + cross( v.normal , float3(0,1,0)) *10000 ;




        float3 normi = UnpackNormal (tex2D (_MainTex, v.uv));
        nor = -normi;


        float3 refl = reflect( v.rd , nor  );
        float rm =  dot( normalize(refl) , _WorldSpaceLightPos0.xyz );

        float4 tCol = tex2D(_MainTex , v.uv);//
        float m = dot( normalize(nor) , _WorldSpaceLightPos0.xyz );
        col = tex2D(_ColorMap, float2( rm *1 ,0)).xyz * (rm) +  tex2D(_ColorMap, float2( m *1 ,0)).xyz * (m)  ;// hsv(d * 10.1,1,1);
        p = v.ro;// + v.rd * d/4;

        
fragmentOutput o;
//convert position to clip space, read depth
float4 clip_pos = mul(UNITY_MATRIX_VP, float4(p, 1.0));
o.zvalue = clip_pos.z / clip_pos.w;



  
        //col /=  float( _NumberSteps);
       // col = dot( normalize(nor) , _WorldSpaceLightPos0.xyz );//normalize(nor) * .5 + .5;//hsv(d,1,1);
        if( hit == false ){
        //  discard;
        }
       

        fixed4 color;
        o.color = fixed4( col , 1. );
        return o;// color;
      }

      ENDCG
    }
  }
  FallBack "Diffuse"
}