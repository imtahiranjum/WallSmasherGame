using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class Image_Controller : MonoBehaviour
{
   public List<Transform> list_images=new List<Transform>(4);
    static Image_Controller inst;
    bool enabler = false;
    [SerializeField] private List<Transform> priavte_list = new List<Transform>(12);

    public Transform p1, p2, p3, p4, p5;
    int num1;
    int num2;
    int num3;

    int num4;

    int num5;

    Dictionary<Transform, Pose_States> image_dict = new Dictionary<Transform, Pose_States>();
    // Start is called before the first frame update
    void Start()
    {
        image_dict.Add(priavte_list[0], Pose_States.idle);
        image_dict.Add(priavte_list[1], Pose_States.sitting3);

        image_dict.Add(priavte_list[2], Pose_States.sitting1);

        image_dict.Add(priavte_list[3], Pose_States.laying2);

        image_dict.Add(priavte_list[4], Pose_States.laying1);

        image_dict.Add(priavte_list[5], Pose_States.kneeling);

        image_dict.Add(priavte_list[6], Pose_States.laying3);

        image_dict.Add(priavte_list[7], Pose_States.laying4);

        image_dict.Add(priavte_list[8], Pose_States.blocking);

        image_dict.Add(priavte_list[9], Pose_States.plank);

        image_dict.Add(priavte_list[10], Pose_States.sitting5);

        image_dict.Add(priavte_list[11], Pose_States.sitting2);
        image_dict.Add(priavte_list[12], Pose_States.sitting4);

        //   image_dict.Add(priavte_list[12], Pose_States.sitting4);





        //p1.transform.position = priavte_list[1].transform.position; p2.transform.position = priavte_list[2].transform.position;
        //p3.transform.position = priavte_list[3].transform.position;
        num1 = 9;
        num2 = 5;
        num3 = 2;
        num4 = 10;
        num5 = 8;
        //num1 = Random.Range(1, 3);
        // num2 = Random.Range(4, 7);
        // num3 = Random.Range(8, 12);
        inst = this;
        list_images.Add(priavte_list[0]);
        list_images.Add(priavte_list[num1]);
        
      //  priavte_list.Remove(priavte_list[num1]);
        list_images.Add(priavte_list[num2]);
       // priavte_list.Remove(priavte_list[num2]);
        list_images.Add(priavte_list[num3]);

        list_images.Add(priavte_list[num4]);

        list_images.Add(priavte_list[num5]);
      //  priavte_list.Remove(priavte_list[num3]);


        image_Pos();
    }
    void image_Pos()
    {
        list_images[1].position = p1.transform.position;
        list_images[2].position = p2.transform.position;

        list_images[3].position = p3.transform.position;
        list_images[4].position = p4.transform.position;
        list_images[5].position = p5.transform.position;

    }
    // Update is called once per frame
    void Update()
    {
        
    }
    public static Image_Controller getInst()
    {
        return inst;
    }

    public  void image_Expander(int index)
    {

       Transform dict_Transform = list_images[index];
        print("Transform key: " + dict_Transform);
        print("Value of state: "+image_dict[dict_Transform]);
       Pose_Controller.getInst().states(image_dict[dict_Transform]);
           list_images[index].DOPunchScale(new Vector3(0.4f, 0.4f, 0.4f), 0.7f,1);
           // StartCoroutine(stopEnabler());
            //foreach (Transform tr in list_images)
            //{
            //    tr.DOPunchScale(new Vector3(0.4f, 0.4f, 0.4f), 2f, 1);
            //}
        

        
    }
    IEnumerator stopEnabler()
    {
        yield return new WaitForSeconds(2f);
        
    }
}
