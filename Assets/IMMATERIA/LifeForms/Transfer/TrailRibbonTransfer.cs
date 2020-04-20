using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TrailRibbonTransfer : TransferLifeForm {
  



  public override void Bind(){

    TrailRibbonVerts v = (TrailRibbonVerts)verts;
    transfer.BindInt( "_RibbonLength" , () => v.length );

    TrailParticles s = (TrailParticles)skeleton;
    transfer.BindInt( "_NumVertsPerHair" , () => s.particlesPerTrail);

  }

}
}