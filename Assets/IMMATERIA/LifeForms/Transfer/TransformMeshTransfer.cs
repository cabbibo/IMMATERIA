using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TransformMeshTransfer : TransferLifeForm
{


  public Form baseBuffer;
  public Particles particles;

  public override void Bind(){

   transfer.BindForm("_BaseBuffer", baseBuffer);
   transfer.BindForm("_VertBuffer", particles);
   transfer.BindInt("_VertsPerMesh",() => baseBuffer.count);
  }
}
}