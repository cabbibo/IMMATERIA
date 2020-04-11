using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindSharkInfo : Binder
{

public float _CurlSize;
public float _CurlSpeed;
public float _CurlForce;
public float _FlowSpeed;

public float _FollowForce;
public float _Dampening;

public float _HumanDist;
public float _HumanForce;

public float _SpacePupRadius;
public float _SpacePupRepelForce;

public override void Bind(){

toBind.BindFloat("_CurlSize", () => _CurlSize);
toBind.BindFloat("_CurlSpeed", () => _CurlSpeed);
toBind.BindFloat("_CurlForce", () => _CurlForce);
toBind.BindFloat("_FlowSpeed", () => _FlowSpeed);
toBind.BindFloat("_FollowForce", () => _FollowForce);
toBind.BindFloat("_Dampening", () => _Dampening);

toBind.BindFloat("_HumanDist", () => _HumanDist);
toBind.BindFloat("_HumanForce", () => _HumanForce);

toBind.BindFloat("_SpacePupRadius", () => _SpacePupRadius);
toBind.BindFloat("_SpacePupRepelForce", () => _SpacePupRepelForce);

}


}
}
