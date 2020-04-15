 using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TubeTransfer : TransferLifeForm {
  

  public override void Create(){

    if( verts == null ){ verts = gameObject.AddComponent<TubeVerts>();}
    if( triangles == null ){ triangles = gameObject.AddComponent<TubeTriangles>();}
  }
  
  public override void Bind(){

    TubeVerts v = (TubeVerts)verts;
    Hair s = (Hair)skeleton;

    transfer.BindInt( "_TubeLength" , () => v.length );
    transfer.BindInt( "_TubeWidth" , () => v.width );
    transfer.BindInt( "_NumVertsPerHair" , () => s.numVertsPerHair  );
  }

}
}