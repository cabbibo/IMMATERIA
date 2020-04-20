using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindVector2 : Binder
{
    
    public string nameInBuffer;
    public Vector2 boundVector2;
    public override void Bind(){
      toBind.BindVector2( nameInBuffer, () => boundVector2 );
    }
}
}