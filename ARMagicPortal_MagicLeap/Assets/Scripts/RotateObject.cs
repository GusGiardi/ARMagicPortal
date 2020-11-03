using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateObject : MonoBehaviour
{
    Transform trans;
    [SerializeField] float velocity;

    void Start()
    {
        trans = transform;
    }

    void Update()
    {
        trans.Rotate(0, velocity * Time.deltaTime, 0);
    }
}
