using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteAlways]
public class OsscilateRotate : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate( transform.right *.03f* Mathf.Sin(Time.time * 1f));
    }
}
