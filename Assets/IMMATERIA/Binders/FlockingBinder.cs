using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class FlockingBinder : Binder
{
public float _CurlSize;
public float _CurlSpeed;
public float _CurlForce;
public float _FlowSpeed;

public float _RepelDist;
public float _RepelForce;
public float _AlignDist;
public float _AlignForce;
public float _AttractDist;
public float _AttractForce;

public float _SpookyDist;
public float _SpookyForce;
public float _CenteringForce;

public float _LifeReduceSpeed;

public float _SpacePupRadius;
public float _SpacePupRepelForce;

public override void Bind(){

toBind.BindFloat("_CurlSize", () => _CurlSize);
toBind.BindFloat("_CurlSpeed", () => _CurlSpeed);
toBind.BindFloat("_CurlForce", () => _CurlForce);
toBind.BindFloat("_FlowSpeed", () => _FlowSpeed);

toBind.BindFloat("_RepelDist", () => _RepelDist);
toBind.BindFloat("_RepelForce", () => _RepelForce);
toBind.BindFloat("_AlignDist", () => _AlignDist);
toBind.BindFloat("_AlignForce", () => _AlignForce);
toBind.BindFloat("_AttractDist", () => _AttractDist);
toBind.BindFloat("_AttractForce", () => _AttractForce);

toBind.BindFloat("_SpookyDist", () => _SpookyDist);
toBind.BindFloat("_SpookyForce", () => _SpookyForce);
toBind.BindFloat("_CenteringForce", () => _CenteringForce);

toBind.BindFloat("_LifeReduceSpeed", () => _LifeReduceSpeed);

toBind.BindFloat("_SpacePupRadius", () => _SpacePupRadius);
toBind.BindFloat("_SpacePupRepelForce", () => _SpacePupRepelForce);

}


}
}
