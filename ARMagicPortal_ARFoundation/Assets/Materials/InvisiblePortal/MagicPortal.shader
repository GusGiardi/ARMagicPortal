Shader "GRD/MagicPortal" {
	SubShader{
		Stencil
		{
			Ref 1
			Comp Always
			Pass Replace
		}
		Tags { "Queue" = "Geometry-1" }  // Write to the stencil buffer before drawing any geometry to the screen
		ColorMask 0 // Don't write to any colour channels
		ZWrite Off // Don't write to the Depth buffer
		Pass{
			Blend Zero One // keep the image behind it
		}
	}
}