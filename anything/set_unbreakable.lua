local ply = Entity(1)

for _, prop in ipairs( ents.FindByClass( "prop_physics" ) ) do

    if IsValid(prop:CPPIGetOwner()) and prop:CPPIGetOwner() == ply then

        prop:SetVar( "Unbreakable", false )
        prop:Fire( "SetDamageFilter", "FilterDamage", 1 )
        duplicator.StoreEntityModifier( prop, "Unbreakable", {On = false} )

    end

end
