using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class HairRibbonVerts: Form {

  public Hair hair;
  public int length;
  public int numHairs;

  public override void SetStructSize(){ structSize = 16; }

  public override void SetCount(){
//    print("hmmm");
    numHairs = hair.numHairs;
    count = numHairs * 2 * length;
  }

}
}