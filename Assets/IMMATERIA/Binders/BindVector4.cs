using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindVector4 : Binder
{
    
    public string nameInBuffer;
    public Vector4 boundVector4;
    public override void Bind(){
      toBind.BindVector4( nameInBuffer, () => boundVector4 );
    }
}
}