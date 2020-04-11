using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class TubeTriangles : IndexForm {

  [ HideInInspector ] public int width;
  [ HideInInspector ] public int length;
  [ HideInInspector ] public int numTubes;
  public TubeVerts verts;

  public override void SetCount(){
    toIndex = verts;
    numTubes = verts.numTubes;
    width = verts.width;
    length = verts.length;
    count = numTubes * width * (length-1) * 3 * 2;
  }

  public override void Embody(){

    int[] values = new int[count];
    int index = 0;
    for( int i = 0; i < numTubes; i++ ){
    for( int j = 0; j < length-1; j++   ){
    for( int k = 0; k < width; k++    ){

        int bID = i * (width+1) * length;

        int id1 = j * (width+1) + k;
        int id2 = j * (width+1) + ((k+1));
        int id3 = (j+1) * (width+1) + k;
        int id4 = (j+1) * (width+1) + ((k+1));

        values[ index ++ ] = bID + id1;
        values[ index ++ ] = bID + id2;
        values[ index ++ ] = bID + id4;
        values[ index ++ ] = bID + id1;
        values[ index ++ ] = bID + id4;
        values[ index ++ ] = bID + id3;

    }
    }
    }
    SetData(values);
  }

}
}
