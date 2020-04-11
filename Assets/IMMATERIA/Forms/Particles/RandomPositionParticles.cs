using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class RandomPositionParticles : Particles
{

  public bool transformPositions;

  public override void SetStructSize(){ structSize = 4; }

  public override void Embody(){
    float[]  values = new float[ count * structSize ];
    int index = 0;

    Vector3 p;
    for( int i = 0; i < count; i++ ){
      p = Random.insideUnitSphere;
      if( transformPositions ){ p = transform.TransformPoint(p);  }
      values[ index ++ ] = p.x;
      values[ index ++ ] = p.y;
      values[ index ++ ] = p.z;
      values[ index ++ ] = i;
    }

    SetData(values);
  }



}}