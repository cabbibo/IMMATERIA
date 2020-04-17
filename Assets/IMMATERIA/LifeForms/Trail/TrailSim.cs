using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TrailSim : Simulation
{

  public Form head;
  public Life transport;


  public override void Create(){
    if( transport ) SafeInsert(transport);
  }

  public override void Bind(){

    life.BindForm("_HeadBuffer", head);

    TrailParticles tp = (TrailParticles)form;
    life.BindInt( "_ParticlesPerTrail" , () => tp.particlesPerTrail );

    if( transport ){
      transport.BindPrimaryForm("_ParticleBuffer" ,head);
      transport.BindForm("_VertBuffer" ,form);
      transport.BindInt( "_NumVertsPerHair" , () => tp.particlesPerTrail );
      data.BindCameraData(transport);
    }

  }


}
}