using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA{
public class BindForm3D : Binder
{
  public Form3D form;
  public string name;
  public override void Bind(){
      toBind.BindForm(name, form);
  }
}}
