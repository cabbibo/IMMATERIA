using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindTransform : Binder
{

    public Matrix4x4 transformMatrix;
    public override void Bind(){
      toBind.BindMatrix("_Transform", () => this.transformMatrix );
    }


    public override void WhileLiving( float v){
//      print(transform.localToWorldMatrix[0]);
      transformMatrix = transform.localToWorldMatrix;
    }
  }
}