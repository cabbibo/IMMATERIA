using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class TrailRibbonTris: IndexForm {

  [ HideInInspector ] public int length;
  [ HideInInspector ] public int numRibbons;
  
  public TrailRibbonVerts verts;

  public override void SetCount(){
    toIndex = verts;
    numRibbons = verts.numRibbons;
    length = verts.length;
    count = numRibbons * (length-1) * 3 * 2;
  }

  public override void Embody(){

    int[] values = new int[count];
    int index = 0;
    for( int i = 0; i < numRibbons; i++ ){
    for( int j = 0; j < length-1; j++   ){

        int bID = i * length * 2;

        int id1 = j * 2 + 0;
        int id2 = j * 2 + 1;
        int id3 = (j+1) * 2 + 0;
        int id4 = (j+1) * 2 + 1;

        values[ index ++ ] = bID + id1;
        values[ index ++ ] = bID + id2;
        values[ index ++ ] = bID + id4;
        values[ index ++ ] = bID + id1;
        values[ index ++ ] = bID + id4;
        values[ index ++ ] = bID + id3;

    }
    }
    SetData(values);
  }

}
}