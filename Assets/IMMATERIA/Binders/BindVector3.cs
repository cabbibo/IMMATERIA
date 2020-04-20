using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindVector3 : Binder
{
    
    public string nameInBuffer;
    public Vector3 boundVector3;
    public override void Bind(){
      toBind.BindVector3( nameInBuffer, () => boundVector3 );
    }
}
}