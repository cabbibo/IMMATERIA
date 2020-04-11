using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class RibbonTransfer : TransferLifeForm {
  
  
  public override void Bind(){

    HairRibbonVerts v = (HairRibbonVerts)verts;
    transfer.BindFloat( "_RibbonLength" , () => v.length );

    Hair h = (Hair)skeleton;
    transfer.BindInt( "_NumVertsPerHair" , () => h.numVertsPerHair );

    
  }

}
}