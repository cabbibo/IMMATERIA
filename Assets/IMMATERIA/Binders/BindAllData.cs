using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindAllData : Binder
{
    
  public override void Bind() {
    data.BindAllData(toBind);
  }
}
}
