using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindFloats : Binder
{
    
    public string nameInBuffer;
    public float[] boundFloats;
    public override void Bind(){
      toBind.BindFloats( nameInBuffer, () => boundFloats );
    }
}
}