using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Timer : MonoBehaviour
{
    // Start is called before the first frame update

    public float timeValue = 3f;
    public Text timeText;
    public TextMeshProUGUI heading;


    private void Start()
    {
        timeValue = 4f;
    }

    // Update is called once per frame
    void Update()
    {
        if(timeValue > 0 && sliderController.is_disabled == false && WallDestroyer.wallCounter > 0)
        {
            heading.text = "Select Pose";
            timeValue -= Time.deltaTime;
            DisplayTime(timeValue);
        }
        else
        {
            heading.text = "";
            timeText.text = "";
            timeValue = 4f;
        }
        
    }

    void DisplayTime(float timeToDisplay)
    {
        timeText.text =  string.Format("{0:0}", timeToDisplay);
    }
}
