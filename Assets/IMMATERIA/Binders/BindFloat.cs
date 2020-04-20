using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindFloat : Binder
{
    
    public string nameInBuffer;
    public float boundFloat;
    public override void Bind(){
      toBind.BindFloat( nameInBuffer, () => boundFloat );
    }
}
}