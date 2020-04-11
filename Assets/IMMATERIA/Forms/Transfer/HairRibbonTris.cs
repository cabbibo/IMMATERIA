using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class HairRibbonTris: IndexForm {

  [ HideInInspector ] public int length;
  [ HideInInspector ] public int numHairs;
  
  public HairRibbonVerts verts;

  public override void SetCount(){
    toIndex = verts;
    numHairs = verts.numHairs;
    length = verts.length;
    count = numHairs * (length-1) * 3 * 2;
  }

  public override void Embody(){

    int[] values = new int[count];
    int index = 0;
    for( int i = 0; i < numHairs; i++ ){
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

}}