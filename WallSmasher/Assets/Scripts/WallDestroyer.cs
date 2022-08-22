using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class globalVar
{
    public static int whichToDestroy = 0;
    
}


public class WallDestroyer : MonoBehaviour
{


    WallControllerScript wallControllerScript;
    [SerializeField] protected GameObject wallController;

    public GameObject[] wall;

    private void Start() {
        globalVar.whichToDestroy = 0;
    }

    private void Awake()
    {
        wallControllerScript = wallController.GetComponent<WallControllerScript>();
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Wall")
        {
            Destroy(wall[globalVar.whichToDestroy]);
            globalVar.whichToDestroy++;
            //Destroy(GameObject.FindWithTag("Wall"));
            wallControllerScript.wallSpeed += 0.5;
        }
    }
}
