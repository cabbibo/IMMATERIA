using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA{
public class ConnectionBuffer : IndexForm
{
    public TriConnectedVerts triConnectedParticles;

    public int[] connections;
    public override void SetCount(){
        
        count = triConnectedParticles.connections.Count;
        print( count );
    }

    public override void Embody(){
        SetData( triConnectedParticles.connections.ToArray() );
    }
}}
