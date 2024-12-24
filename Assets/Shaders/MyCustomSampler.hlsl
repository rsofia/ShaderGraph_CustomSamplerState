//UNITY_SHADER_NO_UPGRADE
#ifndef MYCUSTOMSAMPLER_INCLUDED
#define MYCUSTOMSAMPLER_INCLUDED
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"

SAMPLER(SamplerState_Trilinear_Repeat_Aniso8);
SAMPLER(SamplerState_Trilinear_Repeat_Aniso4);
SAMPLER(SamplerState_Trilinear_Repeat_Aniso2);
SAMPLER(SamplerState_Trilinear_Repeat);

void CustomSampler_float(int anisoIndex, out bool hasAniso, out UnitySamplerState state)
{
    hasAniso = true;
    if(anisoIndex == 1)
    {
        state = UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat_Aniso2);
    }
    else if(anisoIndex == 2)
    {
        state = UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat_Aniso4);
    }
    else if(anisoIndex == 3)
    {
        state = UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat_Aniso8);
    }
    else
    {
        //when anisoIndex is 0 aniso is Off
        state = UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat);
        hasAniso = false;
    }
}

void CustomSampler_half(int anisoIndex, out bool hasAniso, out UnitySamplerState state)
{
    hasAniso = true;
    if(anisoIndex == 1)
    {
        state = UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat_Aniso2);
    }
    else if(anisoIndex == 2)
    {
        state = UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat_Aniso4);
    }
    else if(anisoIndex == 3)
    {
        state = UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat_Aniso8);
    }
    else
    {
        //when anisoIndex is 0 aniso is Off
        state = UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat);
        hasAniso = false;
    }
}

#endif 