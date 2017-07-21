use "collections"
use "time"

actor Main
  new create(env: Env) =>
    let total: U64 = try
      let total' = env.args(1).u64()
      if total' <= 1 then error else total' end
    else
      5
    end
    let states = StateList(total)
    env.out.print(total.string() + " philosophers sit at the table.")

    let timers = Timers
    for n in Range[U64](1, total + 1) do
      let philosopher = Philosopher(env, n, total, states)
      let timer = Timer(PhilosopherAction(philosopher), 0, 400_000_000)
      timers(consume timer)
    end
