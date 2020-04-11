using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TubeVerts: Form {

  public Hair hair;
  public int width;
  public int length;
  public int numTubes;

  public override void SetStructSize(){ structSize = 16; }

  public override void SetCount(){
    numTubes = hair.numHairs;
    count = numTubes * (width+1) * length;
  }

}
}




