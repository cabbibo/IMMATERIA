using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ClothTris : IndexForm
{


    private ClothVerts clothVerts;

    public override void Create(){
        if( toIndex == null ){ toIndex  = GetComponent<ClothVerts>(); }
        clothVerts = (ClothVerts)toIndex;
    }
    public override void SetCount(){
        count = (clothVerts.numVertsX-1) * (clothVerts.numVertsY-1) * 6;
    }


    
  public override void Embody(){

    int[] values = new int[count];
    int index = 0;

    // 1-0
    // |/|
    // 3-2
    for( int i = 0; i < clothVerts.numVertsX-1; i++ ){
    for( int j = 0; j < clothVerts.numVertsY-1; j++ ){


        int id1 = i + j * clothVerts.numVertsX;
        int id2 = i+1 + j * clothVerts.numVertsX;
        int id3 = i + (j+1) * clothVerts.numVertsX;
        int id4 = i+1 + (j+1) * clothVerts.numVertsX;

        values[ index ++ ] = id1;
        values[ index ++ ] = id2;
        values[ index ++ ] = id4;
        values[ index ++ ] = id1;
        values[ index ++ ] = id4;
        values[ index ++ ] = id3;
    
    }}
    SetData(values);
  }


}
}
