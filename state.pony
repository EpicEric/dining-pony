use "collections"

primitive Thinking
primitive Hungry
primitive Eating

type State is (Thinking | Hungry | Eating)

actor StateList
  let _states: Map[U64, State] = _states.create()

  new create(total: U64) =>
    for n in Range[U64](1, total + 1) do
      _states.update(n, Thinking)
    end

  be access(fn: {(StateList ref)} val) =>
    fn(this)

  fun ref write(n: U64, s: State) =>
    _states.update(n, s)

  fun ref read(n: U64): State =>
    _states.get_or_else(n, Eating)
