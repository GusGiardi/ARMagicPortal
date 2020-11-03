using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EyeMoon : MonoBehaviour
{
    [SerializeField] Transform cameraTransform;
    [SerializeField] Transform portalTransform;
    Material myMaterial;
    [SerializeField] float sensitivity = 1;

    void Start()
    {
        myMaterial = GetComponent<Renderer>().material;
    }

    void Update()
    {
        myMaterial.SetVector("_EyeDirection", portalTransform.InverseTransformPoint(cameraTransform.position));
    }
}
