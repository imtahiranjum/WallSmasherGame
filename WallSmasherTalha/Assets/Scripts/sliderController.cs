using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class sliderController : MonoBehaviour
{
    // Dictionary<int, string> pose_values=new Dictionary<int, string>();
    // Start is called before the first frame update

    [SerializeField] public Slider slider;
    public static bool is_disabled = false;

    static sliderController inst;
    // Dictionary<int, string> pose_values=new Dictionary<int, string>();
    // Start is called before the first frame update
    void Start()
    {
        inst = this;
        slider.enabled = true;
        //slider.interactable = true;
        is_disabled = false;
        StartCoroutine(disableSlider());
        //pose_values.Add(0, "Idle_Image");
        //pose_values.Add(1, "Image1");
        //pose_values.Add(2, "Image2");
        //pose_values.Add(3, "Image3");

    }

    public static sliderController getInstance()
    {
        return inst;
    }
    // Update is called once per frame
    void Update()
    {
        
    }

    public void sliderValues()
    {




        switch ((int)slider.value)
        {
            case 0:
                Image_Controller.getInst().image_Expander(0); //Pose_Controller.getInst().states(Pose_States.idle);
                Pose_Controller.getInst().states(Pose_States.poses_off); StartCoroutine(PoseOn());

                break;

            case 1:
                Image_Controller.getInst().image_Expander(1); //Pose_Controller.getInst().states(Pose_States.plank);
                Pose_Controller.getInst().states(Pose_States.poses_off); StartCoroutine(PoseOn());
                //StartCoroutine(slider_default());
                break;

            case 2:
                Image_Controller.getInst().image_Expander(2); //Pose_Controller.getInst().states(Pose_States.laying4);
                Pose_Controller.getInst().states(Pose_States.poses_off); StartCoroutine(PoseOn());
                //StartCoroutine(slider_default());
                break;

            case 3:
                Image_Controller.getInst().image_Expander(3); //Pose_Controller.getInst().states(Pose_States.sitting2);
                Pose_Controller.getInst().states(Pose_States.poses_off); StartCoroutine(PoseOn());
                //StartCoroutine(slider_default());
                break;

            case 4:
                Image_Controller.getInst().image_Expander(4); //Pose_Controller.getInst().states(Pose_States.sitting2);
                Pose_Controller.getInst().states(Pose_States.poses_off); StartCoroutine(PoseOn());
                //StartCoroutine(slider_default());
                break;

            case 5:
                Image_Controller.getInst().image_Expander(5); //Pose_Controller.getInst().states(Pose_States.sitting2);
                Pose_Controller.getInst().states(Pose_States.poses_off); StartCoroutine(PoseOn());
                //StartCoroutine(slider_default());
                break;



        }
    }
    IEnumerator PoseOn()
    {
        yield return new WaitForSeconds(1f);
        Pose_Controller.getInst().states(Pose_States.poses);
    }

    IEnumerator disableSlider()
    {
        yield return new WaitForSeconds(3f);
        slider.interactable = false;
        is_disabled = true;
    }

    // IEnumerator slider_default()
    // {
    //     yield return new WaitForSeconds(2f);
    //     slider.value = 0;
    // }
}
