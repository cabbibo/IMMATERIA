using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindInt : Binder
{
    
    public string nameInBuffer;
    public int boundInt;
    public override void Bind(){
      toBind.BindInt( nameInBuffer, () => boundInt );
    }
}
}