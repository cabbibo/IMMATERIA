using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class OsscilateTransforms : Cycle
{

  public TransformBuffer b;

  public float _OsscilateSpeed1;
  public float _OsscilateSize1;


  public float _OsscilateSpeed2;
  public float _OsscilateSize2;


    public float _OsscilateSpeed3;
  public float _OsscilateSize3;

  public override void WhileLiving( float v){

    float t = data.time;
    
    for( int i = 0; i < b.transforms.Length; i++){

      float offset1 = Mathf.Sin((float)i *1000);
      float offset2 = Mathf.Sin((float)i *2000);
      float offset3 = Mathf.Sin((float)i *3000);

      float x = Mathf.Sin(t * _OsscilateSpeed1  * ((Mathf.Sin(t * _OsscilateSpeed2 ) + 4)/5)+ offset1 ) * _OsscilateSize1;
      float y = Mathf.Sin(t * _OsscilateSpeed1  * ((Mathf.Sin(t * _OsscilateSpeed2 ) + 4)/5)+ offset1*2) * _OsscilateSize1;
      float z = Mathf.Sin(t * _OsscilateSpeed1  * ((Mathf.Sin(t * _OsscilateSpeed2 ) + 4)/5)+ offset1*3 ) * _OsscilateSize1;
      Vector3 fPos = new Vector3(x,y,z);

        b.transforms[i].localPosition = fPos;

    }


  }
}
}