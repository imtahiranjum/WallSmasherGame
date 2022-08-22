using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WallControllerScript : MonoBehaviour
{

    [SerializeField] protected GameObject wallController;

    public double wallSpeed = 5f;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

        MoveObj(wallController);

    }

    private void MoveObj(GameObject walls)
    {
        Vector3 pos = new Vector3(0f, 0f, (float)-wallSpeed * Time.deltaTime);
        walls.transform.position += pos;
    }

}
