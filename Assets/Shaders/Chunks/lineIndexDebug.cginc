

 uniform int _Count;
      uniform float3 _Color;





      StructuredBuffer<Vert> _VertBuffer;
      StructuredBuffer<int> _TriBuffer;

      //A simple input struct for our pixel shader step containing a position.
      struct varyings {
          float4 pos : SV_POSITION;
      };

      //Our vertex function simply fetches a point from the buffer corresponding to the vertex index
      //which we transform with the view-projection matrix before passing to the pixel program.
      varyings vert (uint id : SV_VertexID){

        varyings o;

        // Getting ID information
        
        int baseTri = id / 6;
        int triID = id % 6;
        int whichTri = triID/2;
        int alternate = id %2;

        // Making sure we aren't looking up into a bad areas
        if( baseTri*3+whichTri < _Count ){

          int t1 = _TriBuffer[baseTri*3+ ((whichTri+0)%3)];
          int t2 = _TriBuffer[baseTri*3+ ((whichTri+1)%3)];


          Vert v1 = _VertBuffer[t1];
          Vert v2 = _VertBuffer[t2];

          float3 pos;
          if( alternate == 0 ){
            pos = v1.pos;
          }else{
            pos = v2.pos;
          }

          o.pos = mul (UNITY_MATRIX_VP, float4(pos,1.0f));
      
        }

        return o;

      }

      //Pixel function returns a solid color for each point.
      float4 frag (varyings v) : COLOR {
          return float4( _Color , 1 );
      }