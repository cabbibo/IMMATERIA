using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindReefParameters : Binder
{
   
  // amount velocity is multiplied every frame
  // to slow movement down.
  // anything over 1 will make it go infinite
  [Range(0.8f, .99f)]
  public float _Dampening;


  // force that makes each vert-particle move back
  // to its original position
  [Range(0.01f, .1f)]
  public float _ReturnStrength;


  // amount the bone fish move the gooey mesh 
  // as they pass by. - = pull , + = push
  [Range(-.01f, .01f)]
  public float _SharkDisplacementForce;


  // how far away bone fish needs to be to displace
  [Range(0.01f, 2.99f)]
  public float _SharkDisplacementRadius;



  //This function is where we actually attach all these values
  // so that they get set in the compute shaders
  public override void Bind(){

    toBind.BindFloat("_Dampening", () => _Dampening );
    toBind.BindFloat("_ReturnStrength", () => _ReturnStrength );
    toBind.BindFloat("_SharkDisplacementForce", () => _SharkDisplacementForce );
    toBind.BindFloat("_SharkDisplacementRadius", () => _SharkDisplacementRadius );

  }






}
}
