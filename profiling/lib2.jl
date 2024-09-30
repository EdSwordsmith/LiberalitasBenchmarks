module Lib2
include("opt/Liberalitas.jl")

@class PokemonType()
@class Fire(PokemonType)
@class Water(PokemonType)
@class Grass(PokemonType)
@class Electric(PokemonType)
@class Normal(PokemonType)
@class Ice(PokemonType)
@class Fighting(PokemonType)
@class Poison(PokemonType)
@class Ground(PokemonType)
@class Flying(PokemonType)
@class Psychic(PokemonType)
@class Bug(PokemonType)
@class Rock(PokemonType)
@class Ghost(PokemonType)
@class Dragon(PokemonType)

@class Charmander(Fire) [health]
@class WaterGun(Water)

@method attack_mult(::PokemonType, ::PokemonType) = 1.0

# Normal attacks
@method attack_mult(::Normal, ::Rock) = 0.5
@method attack_mult(::Normal, ::Ghost) = 0.0

# Fire attacks
@method attack_mult(::Fire, ::Fire) = 0.5
@method attack_mult(::Fire, ::Water) = 0.5
@method attack_mult(::Fire, ::Grass) = 2.0
@method attack_mult(::Fire, ::Ice) = 2.0
@method attack_mult(::Fire, ::Bug) = 2.0
@method attack_mult(::Fire, ::Rock) = 0.5
@method attack_mult(::Fire, ::Dragon) = 0.5

# Water attacks
@method attack_mult(::Water, ::Fire) = 2.0
@method attack_mult(::Water, ::Water) = 0.5
@method attack_mult(::Water, ::Grass) = 0.5
@method attack_mult(::Water, ::Ground) = 2.0
@method attack_mult(::Water, ::Rock) = 2.0
@method attack_mult(::Water, ::Dragon) = 0.5

# Electric attacks
@method attack_mult(::Electric, ::Water) = 2.0
@method attack_mult(::Electric, ::Electric) = 0.5
@method attack_mult(::Electric, ::Grass) = 0.5
@method attack_mult(::Electric, ::Ground) = 0.0
@method attack_mult(::Electric, ::Flying) = 2.0
@method attack_mult(::Electric, ::Dragon) = 0.5

# Grass attacks
@method attack_mult(::Grass, ::Fire) = 0.5
@method attack_mult(::Grass, ::Water) = 2.0
@method attack_mult(::Grass, ::Grass) = 0.5
@method attack_mult(::Grass, ::Poison) = 0.5
@method attack_mult(::Grass, ::Ground) = 2.0
@method attack_mult(::Grass, ::Flying) = 0.5
@method attack_mult(::Grass, ::Bug) = 0.5
@method attack_mult(::Grass, ::Rock) = 2.0
@method attack_mult(::Grass, ::Dragon) = 0.5

# Ice attacks
@method attack_mult(::Ice, ::Water) = 0.5
@method attack_mult(::Ice, ::Grass) = 2.0
@method attack_mult(::Ice, ::Ice) = 0.5
@method attack_mult(::Ice, ::Ground) = 2.0
@method attack_mult(::Ice, ::Flying) = 2.0
@method attack_mult(::Ice, ::Dragon) = 2.0

# Fighting attacks
@method attack_mult(::Fighting, ::Normal) = 2.0
@method attack_mult(::Fighting, ::Ice) = 2.0
@method attack_mult(::Fighting, ::Poison) = 0.5
@method attack_mult(::Fighting, ::Flying) = 0.5
@method attack_mult(::Fighting, ::Psychic) = 0.5
@method attack_mult(::Fighting, ::Bug) = 0.5
@method attack_mult(::Fighting, ::Rock) = 2.0
@method attack_mult(::Fighting, ::Ghost) = 0.0

# Poison attacks
@method attack_mult(::Poison, ::Grass) = 2.0
@method attack_mult(::Poison, ::Poison) = 0.5
@method attack_mult(::Poison, ::Ground) = 0.5
@method attack_mult(::Poison, ::Bug) = 2.0
@method attack_mult(::Poison, ::Rock) = 0.5
@method attack_mult(::Poison, ::Ghost) = 0.5

# Ground attacks
@method attack_mult(::Ground, ::Fire) = 2.0
@method attack_mult(::Ground, ::Electric) = 2.0
@method attack_mult(::Ground, ::Grass) = 0.5
@method attack_mult(::Ground, ::Poison) = 2.0
@method attack_mult(::Ground, ::Flying) = 0.0
@method attack_mult(::Ground, ::Bug) = 0.5
@method attack_mult(::Ground, ::Rock) = 2.0

# Flying attacks
@method attack_mult(::Flying, ::Electric) = 0.5
@method attack_mult(::Flying, ::Grass) = 2.0
@method attack_mult(::Flying, ::Fighting) = 2.0
@method attack_mult(::Flying, ::Bug) = 2.0
@method attack_mult(::Flying, ::Rock) = 0.5

# Psychic attacks
@method attack_mult(::Psychic, ::Fighting) = 2.0
@method attack_mult(::Psychic, ::Poison) = 2.0
@method attack_mult(::Psychic, ::Psychic) = 0.5

# Bug attacks
@method attack_mult(::Bug, ::Fire) = 0.5
@method attack_mult(::Bug, ::Grass) = 2.0
@method attack_mult(::Bug, ::Fighting) = 0.5
@method attack_mult(::Bug, ::Poison) = 2.0
@method attack_mult(::Bug, ::Flying) = 0.5
@method attack_mult(::Bug, ::Psychic) = 2.0
@method attack_mult(::Bug, ::Ghost) = 0.5

# Rock attacks
@method attack_mult(::Rock, ::Fire) = 2.0
@method attack_mult(::Rock, ::Ice) = 2.0
@method attack_mult(::Rock, ::Fighting) = 0.5
@method attack_mult(::Rock, ::Ground) = 0.5
@method attack_mult(::Rock, ::Flying) = 2.0
@method attack_mult(::Rock, ::Bug) = 2.0

# Ghost attacks
@method attack_mult(::Ghost, ::Normal) = 0.0
@method attack_mult(::Ghost, ::Psychic) = 0.0
@method attack_mult(::Ghost, ::Ghost) = 2.0

# Dragon attacks
@method attack_mult(::Dragon, ::Dragon) = 2.0
end
