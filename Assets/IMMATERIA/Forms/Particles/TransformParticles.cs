using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TransformParticles : Particles
{

  TransformBuffer transforms;

  float[] values;

  public override void Create(){

  }

  public override void WhileLiving(float v){
    if( transforms.dynamic ){
      for( int i = 0; i < transforms.transforms.Length; i++ ){
          Transform t = transforms.transforms[i];
          values[i * 16 + 0 ] = t.position.x;
          values[i * 16 + 1 ] = t.position.y;
          values[i * 16 + 2 ] = t.position.z;

          values[i * 16 + 3 ] = t.position.x;
          values[i * 16 + 4 ] = t.position.y;
          values[i * 16 + 5 ] = t.position.z;

          values[i * 16 + 6 ] = t.up.x;
          values[i * 16 + 7 ] = t.up.y;
          values[i * 16 + 8 ] = t.up.z;

          values[i * 16 + 9 ] = t.up.x;
          values[i * 16 + 10 ] = t.up.y;
          values[i * 16 + 11 ] = t.up.z;

          values[i * 16 + 12 ] = i;
          values[i * 16 + 13 ] = (float)i/transforms.transforms.Length;

          values[i * 16 + 12 ] = 0;
          values[i * 16 + 13 ] = 0;

      }

      SetData( values );
    }
  }




}
}