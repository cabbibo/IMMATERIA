using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class PlaceDynamicMeshParticles : Simulation
{
  public Form meshVerts;

  public override void Create(){

    if( ((ParticlesOnDynamicMesh)form).mesh == null ){
       ((ParticlesOnDynamicMesh)form).mesh = ((MeshVerts)meshVerts).mesh;
    }
  }
  public override void Bind(){

    life.BindForm("_VertBuffer" , meshVerts );

  }
}
}
