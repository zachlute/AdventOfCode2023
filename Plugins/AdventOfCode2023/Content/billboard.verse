using { /Fortnite.com/Devices }
using { /Verse.org/Simulation/Tags }

billboard_tag := class(tag){}

SetBillboardText(Text : string) : void =
    if (Billboard : billboard_device := billboard_device[GetCreativeObjectsWithTag(billboard_tag {})[0]]):
        Billboard.SetText(SetDynamicText(Text))

SetDynamicText<localizes>(value:string) : message="{value}"