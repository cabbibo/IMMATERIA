using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TransformBuffer : Form
{

  public Transform[] transforms;
  public bool dynamic;
  [HideInInspector]public float[] values;
  private float[] tmpVals;

  public override void SetStructSize(){ structSize = 32; }
  public override void SetCount(){ count = transforms.Length; }

  public override void Embody(){
    values = new float[ count * structSize ];
    tmpVals = new float[ 16 ];
    SetInfo();
  }
  public void SetInfo(){
  
    for( int i = 0; i < transforms.Length; i++ ){
      tmpVals = HELP.GetMatrixFloats(transforms[i].localToWorldMatrix);
      for( int j = 0; j < 16; j++ ){
        values[i * 32 + j ] = tmpVals[j];
      }

      tmpVals = HELP.GetMatrixFloats(transforms[i].worldToLocalMatrix);
      for( int j = 0; j < 16; j++ ){
        values[i * 32 + j + 16 ] = tmpVals[j];
      }
    }

    SetData(values);
  }


  public override void WhileLiving( float v ){

    if( dynamic && active ){
      SetInfo();
    }
  }
}
}