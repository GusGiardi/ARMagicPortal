using MagicLeap.Core;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;

public class MLPlaceOnPlane : MonoBehaviour
{
    [SerializeField] ARPortal arPortal;
    [SerializeField] MLRaycastBehavior raycastBehavior;
    [SerializeField] LineRenderer raycastLine;
    [SerializeField] Transform raycastHitObject;
    [SerializeField] Renderer raycastHitRenderer;
    bool raycastHit;

    void OnEnable()
    {
        raycastBehavior.OnRaycastResult += OnRaycastHit;
        MLInput.OnTriggerDown += OnTriggerDown;
    }

    private void OnDisable()
    {
        raycastBehavior.OnRaycastResult -= OnRaycastHit;
        MLInput.OnTriggerDown -= OnTriggerDown;
    }

    public void OnRaycastHit(MLRaycast.ResultState state, MLRaycastBehavior.Mode mode, Ray ray, RaycastHit result, float confidence)
    {
        if (confidence < 0.1f)
        {
            //no hit
            raycastHitRenderer.enabled = false;
            raycastHit = false;

            raycastLine.SetPosition(0, ray.origin);
            raycastLine.SetPosition(1, ray.origin + transform.forward);
        }
        else
        {
            if (Mathf.Abs(result.normal.y) > 0.05f)
            {
                //it is not a wall
                raycastHitRenderer.enabled = true;
                raycastHit = false;

                raycastLine.SetPosition(0, ray.origin);
                raycastLine.SetPosition(1, result.point);

                raycastHitObject.position = result.point;
                raycastHitObject.rotation = Quaternion.LookRotation(result.normal, Vector3.up);

                raycastHitRenderer.material.SetColor("_EmissionColor", Color.red);
            }
            else
            {
                //hit on wall
                raycastHitRenderer.enabled = true;
                raycastHit = true;

                raycastLine.SetPosition(0, ray.origin);
                raycastLine.SetPosition(1, result.point);

                raycastHitObject.position = result.point;
                raycastHitObject.rotation = Quaternion.LookRotation(result.normal, Vector3.up);

                raycastHitRenderer.material.SetColor("_EmissionColor", Color.green);
            }
        }
    }

    private void OnTriggerDown(byte controllerId, float triggerValue)
    {
        if (raycastHit)
        {
            arPortal.CreatePortal(raycastHitObject.position, raycastHitObject.forward, Vector3.up);
        }
    }
}
