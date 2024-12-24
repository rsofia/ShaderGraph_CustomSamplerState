# Custom Sampler State Node in Shader Graph

* Created and tested with Unity 6000.0.31f1 and HDRP 17.

Have you ever wanted more precise control of the Aniso Level used by the Sampler State in your ShaderGraph shader?

In Unity, you can set the Aniso Level directly on the Texture Imported. However, this information is not always the one used as it can essentially be overwritten
by a shader (any shader, it's not specific to ShaderGraph).

It's super common that when sampling textures the Sampling State comes directly from the texture settings. But keep in mind that this data is *supplemental* to the texture, and it's not exactly part of it. 

In ShaderGraph, if you use the Sample Texture 2D node with the default Sampler, it will pull the settings directly from the texture. 

![Default Sample Texture 2D with default Sampler](https://github.com/rsofia/ShaderGraph_CustomSamplerState/blob/main/resources/DefaultSampler2D.png)

The thing is that most graphics APIs support having fewer samplers than textures, and that's why it's possible to overwrite them. This is used as an optimization feature, as these graphics APIs
have a hard limit of the number of samplers they can use. So, all of this means that, in a shader, the texture and the sampler state are separate. 

Currently (as of ShaderGraph 17.0.3), you can overwrite the Aniso Level in Shader Graph by using a [Sampler State node](https://docs.unity3d.com/Packages/com.unity.shadergraph@17.0/manual/Sampler-State-Node.html). However, it's not very UX friendly. To be able to set the Anisotropic
Filterning level on Sampler State Node, you have to set the `Filter` to `Trilinear`, then select the node, and on the Graph Inspector set the Anisotropic Filtering: 

 ![Sampler State Node](https://github.com/rsofia/ShaderGraph_CustomSamplerState/blob/main/resources/SamplerStateNode.png)

 There's also the Sampler State property, however it's not currently possible to set the Aniso Level with it: 
 
  ![Sampler State Property](https://github.com/rsofia/ShaderGraph_CustomSamplerState/blob/main/resources/SamplerStateProperty.png)

How else could you determine the aniso level? With a [custom function](https://docs.unity3d.com/Packages/com.unity.shadergraph@17.0/manual/Custom-Function-Node.html)!

I created a custom function that returns a SamplerState according to the provided aniso level. The .hlsl file has all the desired sampler states included. 

```
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
```

This custom function is used in a Subgraph that takes in a Dropdown to specify the desired Aniso Level, and it outputs the SamplerState. 

 ![Subgraph](https://github.com/rsofia/ShaderGraph_CustomSamplerState/blob/main/resources/Subgraph.png)

And with this approach, you can simply include the Subgraph in your Graph! You can find the subgraph in Assets > Shaders > Subgraph_CustomSampler. Here are the results: 

The first is with Aniso Disabled:

 ![Aniso Off](https://github.com/rsofia/ShaderGraph_CustomSamplerState/blob/main/resources/Custom_AnisoDisabled.png)

And here is with Aniso x8:
![Aniso x8](https://github.com/rsofia/ShaderGraph_CustomSamplerState/blob/main/resources/Custom_Anisox8.png)



## Resources: 
* The texture is from [Outdoor Ground Textures ](https://assetstore.unity.com/packages/2d/textures-materials/floors/outdoor-ground-textures-12555) by "A dog's life software"

