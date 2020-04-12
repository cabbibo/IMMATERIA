using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ParticleTransferVerts: Form {


  public Particles particles;
  public float countMultiplier = 1;


  public override void _Create(){
    
    if( mpb == null ){ mpb = new MaterialPropertyBlock(); }
    if( particles == null ){particles = GetComponent<Particles>(); }
    SetStructSize();
    SetCount();
    SetBufferType();
    DoCreate();
    Create();
  }
  public override void SetStructSize(){ structSize = 16; }

  public override void SetCount(){
    
    // 0-1
    // |/|
    // 2-3
    count = (int)((float)(particles.count * 4) * countMultiplier);


    DebugThis("Count set");
  }

  public override void OnLive(){
    DebugThis("Lving");
    print(this._buffer);
  }

  

}



}