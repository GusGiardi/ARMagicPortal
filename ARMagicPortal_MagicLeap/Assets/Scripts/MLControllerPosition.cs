using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;

public class MLControllerPosition : MonoBehaviour
{
    [SerializeField] MLControllerConnectionHandlerBehavior _controllerConnectionHandler;

    void Start()
    {
        
    }

    void Update()
    {
        //Follow Controller
        if (_controllerConnectionHandler.IsControllerValid())
        {
#if PLATFORM_LUMIN
            MLInput.Controller controller = _controllerConnectionHandler.ConnectedController;
            if (controller.Type == MLInput.Controller.ControlType.Control)
            {
                transform.position = controller.Position;
                transform.rotation = controller.Orientation;
            }
#endif
        }
    }
}
