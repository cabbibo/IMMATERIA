using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class MeshHairTransfer : TransferLifeForm
{
    
    public float meshLength;

    public MeshVerts baseVerts;


    // x = 0 , y = 1 , z = 2
    // tells us what direction the original 
    // mesh is in!
    public int direction;

    public override void Bind(){


    transfer.BindFloat( "_ModelLength" , () => meshLength );
    transfer.BindInt( "_NumVertsPerMesh" , () => baseVerts.count );

    Hair s = (Hair)skeleton;
    transfer.BindInt( "_NumVertsPerHair" , () => s.numVertsPerHair );
    transfer.BindInt( "_Direction" , () => direction);

    transfer.BindForm( "_BaseBuffer" , baseVerts );


    }


}
}