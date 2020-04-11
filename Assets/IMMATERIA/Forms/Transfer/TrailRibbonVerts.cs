using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TrailRibbonVerts: Form {

  public Particles heads;
  public int length;
  public int numRibbons;

  public override void SetStructSize(){ structSize = 16; }

  public override void SetCount(){
//    print("hmmm");
    numRibbons = heads.count;
    count = numRibbons * 2 * length;
  }

}
}