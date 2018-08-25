using UnityEngine;
using UnityEngine.UI;

public class TargetMaskController : MonoBehaviour
{	
	public Dropdown m_Dropdown = null;
	public Material sobelFilteringMaterial = null;

	void Start()
	{
		if(m_Dropdown != null)
		{
			m_Dropdown.onValueChanged.AddListener(delegate {
				DropdownValueChanged(m_Dropdown);
			});
		}
	}

	void DropdownValueChanged(Dropdown change)
	{
		Color targetColor = Convert2Color(m_Dropdown.options[change.value].text);
		if(sobelFilteringMaterial != null)
		{
			sobelFilteringMaterial.SetColor("_TargetMaskColor", targetColor);
		}
	}

	private Color Convert2Color(string color)
	{
		switch(color)
		{
			case "Object":
				return Color.red;
			case "Outline":
				return Color.blue;
			case "Background":
				return Color.green;
			default:
				return Color.red;
		}
	}
}
