using BenchmarkTools

include("mop/Liberalitas.jl")

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

@class Pokemon()
@class Lotad(Pokemon, Water, Grass)
@class Charmander(Pokemon, Fire)
@class Gastly(Pokemon, Ghost)

@method attack_mult(::PokemonType, ::Pokemon) = 1

# Normal attacks
@method attack_mult[around](::Normal, ::Rock) = 0.5 * next()
@method attack_mult[around](::Normal, ::Ghost) = 0

# Fire attacks
@method attack_mult[around](::Fire, ::Fire) = 0.5 * next()
@method attack_mult[around](::Fire, ::Water) = 0.5 * next()
@method attack_mult[around](::Fire, ::Grass) = 2 * next()
@method attack_mult[around](::Fire, ::Ice) = 2 * next()
@method attack_mult[around](::Fire, ::Bug) = 2 * next()
@method attack_mult[around](::Fire, ::Rock) = 0.5 * next()
@method attack_mult[around](::Fire, ::Dragon) = 0.5 * next()

# Water attacks
@method attack_mult[around](::Water, ::Fire) = 2 * next()
@method attack_mult[around](::Water, ::Water) = 0.5 * next()
@method attack_mult[around](::Water, ::Grass) = 0.5 * next()
@method attack_mult[around](::Water, ::Ground) = 2 * next()
@method attack_mult[around](::Water, ::Rock) = 2 * next()
@method attack_mult[around](::Water, ::Dragon) = 0.5 * next()

# Electric attacks
@method attack_mult[around](::Electric, ::Water) = 2 * next()
@method attack_mult[around](::Electric, ::Electric) = 0.5 * next()
@method attack_mult[around](::Electric, ::Grass) = 0.5 * next()
@method attack_mult[around](::Electric, ::Ground) = 0
@method attack_mult[around](::Electric, ::Flying) = 2 * next()
@method attack_mult[around](::Electric, ::Dragon) = 0.5 * next()

# Grass attacks
@method attack_mult[around](::Grass, ::Fire) = 0.5 * next()
@method attack_mult[around](::Grass, ::Water) = 2 * next()
@method attack_mult[around](::Grass, ::Grass) = 0.5 * next()
@method attack_mult[around](::Grass, ::Poison) = 0.5 * next()
@method attack_mult[around](::Grass, ::Ground) = 2 * next()
@method attack_mult[around](::Grass, ::Flying) = 0.5 * next()
@method attack_mult[around](::Grass, ::Bug) = 0.5 * next()
@method attack_mult[around](::Grass, ::Rock) = 2 * next()
@method attack_mult[around](::Grass, ::Dragon) = 0.5 * next()

# Ice attacks
@method attack_mult[around](::Ice, ::Water) = 0.5 * next()
@method attack_mult[around](::Ice, ::Grass) = 2 * next()
@method attack_mult[around](::Ice, ::Ice) = 0.5 * next()
@method attack_mult[around](::Ice, ::Ground) = 2 * next()
@method attack_mult[around](::Ice, ::Flying) = 2 * next()
@method attack_mult[around](::Ice, ::Dragon) = 2 * next()

# Fighting attacks
@method attack_mult[around](::Fighting, ::Normal) = 2 * next()
@method attack_mult[around](::Fighting, ::Ice) = 2 * next()
@method attack_mult[around](::Fighting, ::Poison) = 0.5 * next()
@method attack_mult[around](::Fighting, ::Flying) = 0.5 * next()
@method attack_mult[around](::Fighting, ::Psychic) = 0.5 * next()
@method attack_mult[around](::Fighting, ::Bug) = 0.5 * next()
@method attack_mult[around](::Fighting, ::Rock) = 2 * next()
@method attack_mult[around](::Fighting, ::Ghost) = 0

# Poison attacks
@method attack_mult[around](::Poison, ::Grass) = 2 * next()
@method attack_mult[around](::Poison, ::Poison) = 0.5 * next()
@method attack_mult[around](::Poison, ::Ground) = 0.5 * next()
@method attack_mult[around](::Poison, ::Bug) = 2 * next()
@method attack_mult[around](::Poison, ::Rock) = 0.5 * next()
@method attack_mult[around](::Poison, ::Ghost) = 0.5 * next()

# Ground attacks
@method attack_mult[around](::Ground, ::Fire) = 2 * next()
@method attack_mult[around](::Ground, ::Electric) = 2 * next()
@method attack_mult[around](::Ground, ::Grass) = 0.5 * next()
@method attack_mult[around](::Ground, ::Poison) = 2 * next()
@method attack_mult[around](::Ground, ::Flying) = 0
@method attack_mult[around](::Ground, ::Bug) = 0.5 * next()
@method attack_mult[around](::Ground, ::Rock) = 2 * next()

# Flying attacks
@method attack_mult[around](::Flying, ::Electric) = 0.5 * next()
@method attack_mult[around](::Flying, ::Grass) = 2 * next()
@method attack_mult[around](::Flying, ::Fighting) = 2 * next()
@method attack_mult[around](::Flying, ::Bug) = 2 * next()
@method attack_mult[around](::Flying, ::Rock) = 0.5 * next()

# Psychic attacks
@method attack_mult[around](::Psychic, ::Fighting) = 2 * next()
@method attack_mult[around](::Psychic, ::Poison) = 2 * next()
@method attack_mult[around](::Psychic, ::Psychic) = 0.5 * next()

# Bug attacks
@method attack_mult[around](::Bug, ::Fire) = 0.5 * next()
@method attack_mult[around](::Bug, ::Grass) = 2 * next()
@method attack_mult[around](::Bug, ::Fighting) = 0.5 * next()
@method attack_mult[around](::Bug, ::Poison) = 2 * next()
@method attack_mult[around](::Bug, ::Flying) = 0.5 * next()
@method attack_mult[around](::Bug, ::Psychic) = 2 * next()
@method attack_mult[around](::Bug, ::Ghost) = 0.5 * next()

# Rock attacks
@method attack_mult[around](::Rock, ::Fire) = 2 * next()
@method attack_mult[around](::Rock, ::Ice) = 2 * next()
@method attack_mult[around](::Rock, ::Fighting) = 0.5 * next()
@method attack_mult[around](::Rock, ::Ground) = 0.5 * next()
@method attack_mult[around](::Rock, ::Flying) = 2 * next()
@method attack_mult[around](::Rock, ::Bug) = 2 * next()

# Ghost attacks
@method attack_mult[around](::Ghost, ::Normal) = 0
@method attack_mult[around](::Ghost, ::Psychic) = 0
@method attack_mult[around](::Ghost, ::Ghost) = 2 * next()

# Dragon attacks
@method attack_mult[around](::Dragon, ::Dragon) = 2 * next()

function attack_n_times(N, charmander, water_gun)
    for _ in 1:N
        attack_mult(water_gun, charmander)
    end
end

charmander = make(Charmander)
water_gun = make(Water)

@benchmark attack_n_times(100000, $charmander, $water_gun)
