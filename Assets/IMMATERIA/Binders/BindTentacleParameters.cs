using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindTentacleParameters : Binder
{


  public float _CurlSize;
  public float _CurlStrength;
  public float _CurlSpeed;
  public float _Dampening;
  public float _OutForce;


  public override void Bind(){

    toBind.BindFloat("_CurlSize", () => _CurlSize );
    toBind.BindFloat("_CurlSpeed", () => _CurlSpeed );
    toBind.BindFloat("_CurlStrength", () => _CurlStrength );
    toBind.BindFloat("_Dampening", () => _Dampening );
    toBind.BindFloat("_OutForce", () => _OutForce );

  }

}
}