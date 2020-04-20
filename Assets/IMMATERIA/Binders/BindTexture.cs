using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindTexture : Binder
{
    
    public string nameInBuffer;
    public Texture boundTexture;
    public override void Bind(){
      toBind.BindTexture( nameInBuffer, () => boundTexture );
    }
}
}