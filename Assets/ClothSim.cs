using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class ClothSim : Cycle
{
    
    public ClothVerts verts;
    public ClothTris tris;
    public ConnectionList connections;

    public Life forces;
    public ConstraintLife constraint;

    public override void Create(){


        if( verts == null ){ verts = GetComponent<ClothVerts>(); }
        if( tris == null ){ tris = GetComponent<ClothTris>(); }
        if( forces == null ){ forces = GetComponent<Life>(); }
        if( constraint == null ){ constraint = GetComponent<ConstraintLife>(); }
        if( connections == null ){ connections = GetComponent<ConnectionList>(); }
        connections.verts = verts;

        SafeInsert( verts );
        SafeInsert( tris );
        SafeInsert( connections );
        SafeInsert( forces );
        SafeInsert( constraint );

    }


    public override void Bind(){

        forces.BindPrimaryForm( "_VertBuffer", verts );
        forces.BindInt("_NumVertsX" , () => verts.numVertsX );
        forces.BindInt("_NumVertsY" , () => verts.numVertsY );
        constraint.BindPrimaryForm("_ConnectionBuffer", connections );
        constraint.BindForm("_VertBuffer", verts );
    }


}
}
