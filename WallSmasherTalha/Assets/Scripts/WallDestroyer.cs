using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class globalVar
{
    public static int whichToDestroy = 0;
    
}


public class WallDestroyer : MonoBehaviour
{
    public static int wallCounter = 5;
    WallControllerScript wallControllerScript;
    [SerializeField] protected GameObject wallController;

    public GameObject[] wall;

    private void Start() {
        wallCounter = 5;
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
            wallCounter--;
            Destroy(wall[globalVar.whichToDestroy]);
            globalVar.whichToDestroy++;
            //Destroy(GameObject.FindWithTag("Wall"));
            wallControllerScript.wallSpeed += 0.5;
        }
    }
}
