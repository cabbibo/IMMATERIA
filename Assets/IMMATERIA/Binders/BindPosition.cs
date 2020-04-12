using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using IMMATERIA;
public class BindPosition : Binder
{
    public string boundName;
    public Transform boundTransform;

    public override void Bind(){
        DebugThis("IM BIDNING");
        print(toBind);
        toBind.BindVector3(boundName, () => boundTransform.position);
    }
}
