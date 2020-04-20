using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindDefinedTransform : Binder
{ 
    public string transformName;
    public Transform transformToBind;


public bool bindInverse;
    public string inverseName;
    
    public bool bindScale;
    public string scaleName;

    
    public override void Bind(){
      toBind.BindMatrix( transformName, () => transformToBind.localToWorldMatrix );
      if( bindInverse ){toBind.BindMatrix( inverseName, () => transformToBind.worldToLocalMatrix );}
      if( bindScale ){toBind.BindFloat( scaleName, () => transformToBind.lossyScale.x );}
    }


  }
}