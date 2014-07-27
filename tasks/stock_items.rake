require './alice'

namespace :items do

  desc "Create wands"
  task :create_wands do
    Wand.create!(name: "Wand of Light",          effect_method: "light")
    Wand.create!(name: "Wand of Darkness",       effect_method: "dark")
    Wand.create!(name: "Wand of Summoning",      effect_method: "summon")
    Wand.create!(name: "Wand of Appearing",      effect_method: "appear")
    Wand.create!(name: "Wand of Teleportation",  effect_method: "teleport")
    Wand.create!(name: "Wand of Wonder",         effect_method: "random")
    Wand.create!(name: "Wand of Magic Missiles", effect_method: "none", is_weapon: true)
    Wand.create!(name: "Wand of Fireballs",      effect_method: "none", is_weapon: true)
    Wand.create!(name: "Wand of Silver Bullets", effect_method: "none", is_weapon: true)
  end

end
