using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA{
public class BindForm3DData : Binder
{
  public Form3D form;

  public override void Bind(){
      toBind.BindVector3("_Dimensions", ()=>form.dimensions );
      toBind.BindVector3("_Extents", ()=>form.extents );
      toBind.BindVector3("_Center",()=> form.center );
  }
}
}
