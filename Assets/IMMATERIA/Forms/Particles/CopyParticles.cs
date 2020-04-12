using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA{
public class CopyParticles : Particles
{

    public Form  formToCopy;
    public int countMultiplier = 1;
    public override void SetCount(){
        count = formToCopy.count * countMultiplier;
    }
   
}

}
