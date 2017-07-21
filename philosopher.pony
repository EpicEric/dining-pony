use "random"
use "time"

actor Philosopher
  let _env: Env
  let _number: U64
  let _left: U64
  let _right: U64
  let _total: U64
  let _states: StateList

  new create(env: Env, number: U64, total: U64, states: StateList) =>
    _env = env
    _number = number
    _left = if number == 1 then total else number - 1 end
    _right = if number == total then 1 else number + 1 end
    _total = total
    _states = states

  be dine() =>
    let env = _env
    let states = _states
    let n = _number; let l = _left; let r = _right
    states.access({(states: StateList ref)(env, n, l, r) => 
      match states.read(n)
      | Thinking =>
        env.out.print("#" + n.string() + ": I'm hungry.")
        states.write(n, Hungry)
      | Hungry =>
        if (not (states.read(l) is Eating) and not (states.read(r) is Eating)) then
          env.out.print("#" + n.string() + ": Yum-yum, spaghetti.")
          states.write(n, Eating)
        else
          env.out.print("(#" + n.string() + " wants to eat but can't!)")
        end
      | Eating =>
        env.out.print("#" + n.string() + ": That was tasty!")
        states.write(n, Thinking)
      end
    } val)

class PhilosopherAction is TimerNotify
  let _philosopher: Philosopher
  let _rand: Rand

  new iso create(philosopher: Philosopher) =>
    _philosopher = philosopher
    _rand = Rand(Time.nanos())
    _rand.next()

  fun ref apply(timer: Timer, count: U64): Bool =>
    if (_rand.u8() >= 224) then
      _philosopher.dine()
    end
    true
