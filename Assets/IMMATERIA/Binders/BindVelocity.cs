using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using IMMATERIA;
public class BindVelocity : Binder
{
    public string boundName;
    public Transform boundTransform;

    public Vector3 oPos;

    public override void Create(){
        oPos = boundTransform.position;
    }
    public override void Bind(){

        toBind.BindVector3(boundName, () => (boundTransform.position-oPos));

    }

    public override void WhileLiving(float v){
        oPos = boundTransform.position;
    }
}
