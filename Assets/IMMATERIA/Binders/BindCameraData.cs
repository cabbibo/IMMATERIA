using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindCameraData : Binder
{
    
  public override void Bind() {
    data.BindCameraData(toBind);
  }
}
}
