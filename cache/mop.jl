# If a type implements this trait, then the type can act as the instance of an object
# Right now the required methods are classof and getslot
abstract type MaybeInstance end
struct IsInstance <: MaybeInstance end
struct IsNotInstance <: MaybeInstance end
MaybeInstance(::Type) = IsNotInstance()

classof(obj::T) where {T} = classof(MaybeInstance(T), obj)
classof(::IsInstance, obj) = error("classof not implemented for ", typeof(obj))
classof(::IsNotInstance, obj) = BuiltIn(typeof(obj))

getslot(obj::T, ::Symbol) where {T} = getslot(MaybeInstance(T), obj)
getslot(::IsInstance, obj, ::Symbol) = error("getslot not implemented for ", typeof(obj))
getslot(::IsNotInstance, obj, ::Symbol) = error("getslot not available for ", typeof(obj))

# Need a parent abstract type to implement generic methods for Julia stuff like Base.show and getproperty
# Any type subtyping this will implement the MaybeInstance trait
abstract type Instance end
MaybeInstance(::Type{<:Instance}) = IsInstance()

function Base.getproperty(obj::Instance, slot::Symbol)
    @assert slot in getslot(classof(obj), :slots)
    getslot(obj, slot)
end

# Generic object struct, which can be used as an instance
# Similar to how Tiny CLOS uses the swindleobj struct to represent instances
mutable struct LibObj <: Instance
    class
    slots
end

classof(obj::LibObj) = getfield(obj, :class)
getslot(obj::LibObj, slot::Symbol) = getfield(getfield(obj, :slots), slot)

function Base.setproperty!(obj::LibObj, slot::Symbol, value)
    @assert slot in getslot(classof(obj), :slots)
    slots = (; getfield(obj, :slots)..., slot => value)
    setfield!(obj, :slots, slots)
end

# Bootstrap the Class object and set its class to itself
Class = LibObj(missing, (name=:Class, slots=(:name, :slots, :dsupers, :cpl)))

Top = LibObj(Class, (name=:Top, slots=(), dsupers=()))
Top.cpl = (Top,)

Object = LibObj(Class, (name=:Object, slots=(), dsupers=(Top,)))
Object.cpl = (Object, Top)

setfield!(Class, :class, Class)
Class.dsupers = (Object,)
Class.cpl = (Class, Object, Top)

# Support for builtin types
struct BuiltIn <: Instance
    type::Type
end

PrimitiveClass = LibObj(Class, (name=:PrimitiveClass, slots=(:name, :slots, :dsupers, :cpl, :type), dsupers=(Class,)))
PrimitiveClass.cpl = (PrimitiveClass, Class.cpl...)

JuliaType = LibObj(Class, (name=:JuliaType, slots=(:type,), dsupers=(Top,), cpl=(Top,)))
JuliaType.cpl = (JuliaType, Top)

classof(::BuiltIn) = PrimitiveClass
function getslot(obj::BuiltIn, slot::Symbol)
    if slot == :slots
        ()
    elseif slot == :dsupers
        (JuliaType,)
    elseif slot == :cpl
        (obj, JuliaType, Top)
    elseif slot == :name
        Symbol(getfield(obj, :type))
    else
        getfield(obj, slot)
    end
end

# This struct is used to represent instances of generic functions
# TODO: better name for Entity struct
mutable struct Entity <: Instance
    class
    methods
    cache

    Entity(class) = new(class, Dict{Tuple,Instance}(), Dict{Tuple,Vector{Instance}}())
end

issubclass(c1::BuiltIn, c2::BuiltIn) = c1.type <: c2.type
issubclass(c1::Instance, c2::Instance) = c2 in c1.cpl

function compatible_args(classes1, classes2)
    if length(classes1) != length(classes2)
        return false
    end

    pairs = zip(classes1, classes2)
    all((pair) -> issubclass(pair[begin], pair[end]), pairs)
end

function args_more_specific(m1_classes::Tuple, m2_classes::Tuple, provided_classes::Tuple)
    if m1_classes[1] == m2_classes[1]
        args_more_specific(m1_classes[2:end], m2_classes[2:end], provided_classes[2:end])
    else
        idx1 = findclass(provided_classes[1], m1_classes[1])
        idx2 = findclass(provided_classes[1], m2_classes[1])
        return idx1 < idx2
    end
end

function findclass(provided_class, arg_class)
    for (k, v) in enumerate(provided_class.cpl)
        if v == arg_class
            return k
        end
    end
end

function apply_methods(methods::Vector{Instance}, args, kwargs)
    next = () -> apply_methods(methods[2:end], args, kwargs)
    # TODO: handle no applicable method
    methods[1].proc(next, args...; kwargs...)
end

# Generic function call
function (e::Entity)(args...; kwargs...)
    args_types = map(classof, args)
    compatible_methods = if haskey(e.cache, args_types)
        e.cache[args_types]
    else
        methods = collect(values(e.methods))
        compatible_methods = filter(method -> compatible_args(args_types, method.types), methods)
        sort!(compatible_methods, lt=(x, y) -> args_more_specific(x, y, args_types), by=method -> method.types)
        e.cache[args_types] = compatible_methods
    end

    apply_methods(compatible_methods, args, kwargs)
end

classof(obj::Entity) = getfield(obj, :class)
getslot(obj::Entity, slot::Symbol) = getfield(obj, slot)

function Base.setproperty!(obj::Entity, slot::Symbol, value)
    @assert slot in getslot(classof(obj), :slots)
    setfield!(obj, slot, value)
end

EntityClass = LibObj(Class, (name=:EntityClass, slots=(:name, :slots, :dsupers, :cpl), dsupers=(Class,)))
EntityClass.cpl = (EntityClass, Class.cpl...)

GenericFunction = LibObj(EntityClass, (name=:GenericFunction, slots=(:methods, :cache), dsupers=(Object,), cpl=(Object, Top)))
GenericFunction.cpl = (GenericFunction, Object.cpl...)

Method = LibObj(Class, (name=:Method, slots=(:types, :proc), dsupers=(Object,), cpl=(Object, Top)))
Method.cpl = (Method, Object.cpl...)

# print_object
print_object = Entity(GenericFunction)
print_object.methods[(Top, Class)] = LibObj(Method, (
    types=(Top, Class),
    proc=function (next, io, class; compact=false)
        if compact
            print(io, class.name)
        else
            print(io, class.name, " (class instance of ", classof(class).name, ")")
            print(io, "\n slots: ", class.slots)
            print(io, "\n direct supers: ", class.dsupers)
        end
    end
))

print_object.methods[(Top, Object)] = LibObj(Method, (
    types=(Top, Object),
    proc=function (next, io, obj; compact)
        print(io, classof(obj).name, "(")
        slots = classof(obj).slots
        if length(slots) > 0
            print(io, slots[begin], "=", getslot(obj, slots[begin]))
            for slot in slots[begin+1:end]
                print(io, ", ", slot, "=", getslot(obj, slot))
            end
        end
        print(io, ")")
    end
))

print_object.methods[(Top, Method)] = LibObj(Method, (
    types=(Top, Method),
    proc=function (next, io, method; compact)
        print(io, classof(method).name, method.types)
    end
))

print_object.methods[(Top, GenericFunction)] = LibObj(Method, (
    types=(Top, GenericFunction),
    proc=function (next, io, gf; compact)
        count = length(gf.methods)
        print(io, classof(gf).name, " with ", count, " ")
        if count != 1
            print(io, "methods")
        else
            print(io, "method")
        end

        if !compact && count > 0
            print(io, ":")
            foreach(p -> print(io, "\n ", p[1]), gf.methods)
        end
    end
))

function Base.show(io::IO, obj::Instance)
    compact = get(io, :compact, true)
    print_object(io, obj; compact=compact)
end

function Base.show(io::IO, ::MIME"text/plain", obj::Instance)
    compact = get(io, :compact, false)
    print_object(io, obj; compact=compact)
end

# compatible_metaclasses
compatible_metaclasses = Entity(GenericFunction)
compatible_metaclasses.methods[(Class, Class)] = LibObj(Method, (
    types=(Class, Class),
    proc=(next, class, super) -> issubclass(classof(class), classof(super))
))

# allocate_instance
allocate_instance = Entity(GenericFunction)
allocate_instance.methods[(Class,)] = LibObj(Method, (
    types=(Class,),
    proc=(next, class) -> LibObj(class, NamedTuple{class.slots}(ntuple(_ -> missing, length(class.slots))))
))

allocate_instance.methods[(EntityClass,)] = LibObj(Method, (
    types=(EntityClass,),
    proc=(next, class) -> Entity(class)
))

# initialize
initialize = allocate_instance(GenericFunction)
initialize.methods[(Object,)] = LibObj(Method, (
    types=(Object,),
    proc=function (next, object; initargs...)
        class_slots = classof(object).slots
        for slot in classof(object).slots
            setproperty!(object, slot, get(initargs, slot, missing))
        end
    end
))

initialize.methods[(GenericFunction,)] = LibObj(Method, (
    types=(GenericFunction,),
    proc=function (next, gf; initargs...) end
))

compute_cpl = allocate_instance(GenericFunction)
compute_cpl.methods[(Class,)] = LibObj(Method, (
    types=(Class,),
    proc=function (next, class)
        visited = Set{Instance}()
        visiting = Set{Instance}()
        cpl = Vector{Instance}()

        function topological(class)
            if class in visited
                return
            elseif class in visiting
                error("Cannot have circular dependencies in class hierarchies")
            end

            push!(visiting, class)

            for super in reverse(class.dsupers)
                topological(super)
            end

            pop!(visiting, class)
            push!(visited, class)
            pushfirst!(cpl, class)
        end

        topological(class)
        tuple(cpl...)
    end
))

initialize.methods[(Class,)] = LibObj(Method, (
    types=(Class,),
    proc=function (next, class; name, initargs...)
        class.name = name
        class.dsupers = get(initargs, :dsupers, (Object,))
        class.slots = get(initargs, :slots, ())
        class.cpl = compute_cpl(class)

        compatible = (super) -> compatible_metaclasses(class, super)
        incompatible_supers = filter(!compatible, class.dsupers)
        if !isempty(incompatible_supers)
            error(
                class, " cannot be a subclass of ", join(incompatible_supers, ", ", " or "), " as its metaclass ",
                classof(class), " isn't compatible with ", join(unique(map(classof, incompatible_supers)), ", ", " and "),
                ". Define a method for compatible_metaclasses to override this."
            )
        end
    end
))

# make
make = allocate_instance(GenericFunction)
make.methods[(Class,)] = LibObj(Method, (
    types=(Class,),
    proc=function (next, class; initargs...)
        instance = allocate_instance(class)
        initialize(instance; initargs...)
        instance
    end
))

# add_method
add_method = make(GenericFunction)
add_method.methods[(GenericFunction, Method)] = make(Method,
    types=(GenericFunction, Method),
    proc=function (next, gf, method)
        for types in keys(gf.cache)
            if compatible_args(types, method.types)
                delete!(gf.cache, types)
            end
        end
        gf.methods[method.types] = method
    end
)

# single inheritance
SingleInheritanceClass = make(Class, name=:SingleInheritanceClass, slots=(:name, :dslots, :slots, :dsupers, :cpl), dsupers=(Class,))
add_method(initialize, make(Method, types=(SingleInheritanceClass,), proc=function (next, class; name, dsupers=(Object,), slots=())
    next()

    if length(class.dsupers) > 1
        error(class, " cannot be a subclass of more than one class as it only supports single inheritance.")
    end

    class.dslots = slots
    class.slots = (union(class.dsupers[1].slots, slots)...,)
    class.cpl = compute_cpl(class)
end))

# multiple inheritance
MultipleInheritanceClass = make(Class, name=:MultipleInheritanceClass, slots=(:name, :dslots, :slots, :dsupers, :cpl), dsupers=(Class,))
add_method(initialize, make(Method, types=(MultipleInheritanceClass,), proc=function (next, class; name, dsupers=(Object,), slots=())
    next()
    class.dslots = slots
    class.slots = (union(slots, map(super -> super.slots, class.dsupers)...)...,)
    class.cpl = compute_cpl(class)
end))

# macros
macro generic(name)
    esc(:($name = make(GenericFunction)))
end

toclass(t::Type) = BuiltIn(t)
toclass(x) = x

macro method(form)
    # TODO: validate syntax?
    @assert form.head == :(=)
    head = form.args[1]
    body = form.args[2]
    generic = head.args[1]
    args = head.args[2:end]

    arg_type(::Symbol) = :Top
    arg_type(arg::Expr) = arg.args[end]
    arg_name(arg::Symbol) = arg
    arg_name(arg::Expr) = length(arg.args) > 1 ? arg.args[1] : :_
    isparams(::Symbol) = false
    isparams(arg::Expr) = arg.head == :parameters
    isnotparams(arg) = !isparams(arg)

    required_args = filter(isnotparams, args)
    params = filter(isparams, args)
    types = Expr(:tuple, map(arg_type, required_args)...)
    names = Expr(:tuple, params..., :next, map(arg_name, required_args)...)
    proc = Expr(:function, names, body)

    esc(quote
        let method = make(Method, types=map(toclass, $types), proc=$proc)
            add_method($generic, method)
        end
    end)
end

macro class(head, slots=Expr(:tuple))
    class_slots = Expr(:tuple, map(QuoteNode, slots.args)...)
    explicit_metaclass = head.args[1] == :isa
    metaclass = explicit_metaclass ? head.args[3] : :Class
    class_head = explicit_metaclass ? head.args[2] : head
    class_name = class_head.args[1]

    class_supers = class_head.args[2:end]
    if isempty(class_supers)
        push!(class_supers, :Object)
    end
    supers = Expr(:tuple, class_supers...)

    esc(quote
        $class_name = make($metaclass, name=$(QuoteNode(class_name)), dsupers=$supers, slots=$class_slots)
    end)
end
