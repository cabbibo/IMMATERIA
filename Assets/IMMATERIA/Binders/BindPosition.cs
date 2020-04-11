using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using IMMATERIA;
public class BindPosition : Binder
{
    public string name;
    public Transform transform;

    public override void Bind(){
        toBind.BindVector3(name, () => transform.position);
    }
}
