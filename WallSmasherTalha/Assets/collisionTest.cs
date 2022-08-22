using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class collisionTest : MonoBehaviour
{
    // Start is called before the first frame update

    private void OnCollisionEnter(Collision other) {
        if(other.gameObject.tag == "testWall"){
            Debug.Log("Collided");
        }
        
    }
}
