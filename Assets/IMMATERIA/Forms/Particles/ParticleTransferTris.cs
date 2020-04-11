using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class ParticleTransferTris : IndexForm {

  public override void SetCount(){
    count = ( toIndex.count/4 ) * 3 * 2;
  }

  public override void Embody(){

    int[] values = new int[count];
    int index = 0;

    // 1-0
    // |/|
    // 3-2
    for( int i = 0; i < count/6; i++ ){
        int bID = i * 4;
        values[ index ++ ] = bID + 0;
        values[ index ++ ] = bID + 1;
        values[ index ++ ] = bID + 3;
        values[ index ++ ] = bID + 0;
        values[ index ++ ] = bID + 3;
        values[ index ++ ] = bID + 2;
    }
    SetData(values);
  }

}

}