using UnityEngine;
using UnityEngine.Rendering;

[RequireComponent(typeof(Camera))]
public class ApplyComputeShaderToCameraView : MonoBehaviour
{
    [SerializeField]
	ComputeShader _computeShader;

	Vector2Int _gpuThreads = new Vector2Int(16, 16);

	RenderTexture _src;
	RenderTexture _target;

	void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		_src = src;

		InitializeRenderTexture();
		DispatchComputeShader();

		Graphics.Blit(_target, dst);
	}

	void InitializeRenderTexture()
	{
		if (_target == null || _target.width != Screen.width || _target.height != Screen.height)
        {
            // Release render texture if we already have one
            if (_target != null){
	            _target.Release();
			}

            // Get a render target
            _target = new RenderTexture(Screen.width, Screen.height, 0);
            _target.enableRandomWrite = true;
            _target.Create();
        }
	}

	void DispatchComputeShader()
	{
        if(!SystemInfo.supportsComputeShaders)
        {
			Debug.LogError("Compute Shader is not Support!!");
			return;
        }
		if(_computeShader == null)
		{
			Debug.LogError("Compute Shader has not been assigned!!");
			return;
		}

		int kernelID = _computeShader.FindKernel("SobelFilterCS");
		_computeShader.SetTexture(kernelID, "_SrcImage", _src);
        _computeShader.SetTexture(kernelID, "_Result", _target);
        _computeShader.Dispatch(kernelID, Mathf.CeilToInt((float)_target.width / _gpuThreads.x), 
										  Mathf.CeilToInt((float)_target.height / _gpuThreads.y), 1);
	}
}
