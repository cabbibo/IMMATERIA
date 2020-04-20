using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA{
public class BindForm3DTexture : Binder
{
  public Form3D form;
  public string name;
  public override void Bind(){
      toBind.BindTexture(name, () => form._texture );
  }
}}

