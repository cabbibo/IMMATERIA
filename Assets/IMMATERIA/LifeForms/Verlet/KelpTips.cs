using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA{
public class KelpTips : Simulation
{

  public Hair hair ;
  public Form baseParticles;

  public override void Create(){
    form.count = baseParticles.count;
  }


  public override void Bind(){

    data.BindCameraData( life );

    life.BindInt( "_NumVertsPerHair" , () => hair.numVertsPerHair );
    life.BindForm( "_HairBuffer" ,hair );

  }
}}
