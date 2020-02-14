# Viaduct

At a meetup the difficulty of testing several processes was discussed, and I wondered if registries could be used to make named processes more async-friendly for tests. This is a proof of concept for that idea.

## Basic Setup

Our app has two GenServers: Alpha and Bravo. Bravo typically makes calls to the Alpha server, but for our tests we want it to call our mock server AlphaMock.

## Registry

We could pass in a pid or a test-specific name for our AlphaMock server, but if we had a lot of other servers to call instead of one, that could add a lot more clutter to our Bravo module. Instead this example takes advantage of OTP's `{:via, module, name}` process names to hopefully simplify it all.

## Check It Out

* **Alpha** `lib/viaduct/alpha.ex`  
Simple incrementing GenServer
* **AlphaMock** `lib/viaduct/alpha_mock.ex`
Mock of Alpha
In this case it extends Alpha's behavior, but your mocking should be whatever's best for your tests.
* **Bravo** `lib/viaduct/bravo.ex`
GenServer that depends on Alpha
Takes a registry option, used to determine name of Alpha server
* **BravoTest** `test/viaduct/bravo_test.exs`
Starts up Registry, AlphaMock, and Bravo; tests against Bravo
Registers AlphaMock server in registry as Alpha and passes registry to Bravo on startup

## Thoughts

It's not as simple or pretty as I'd like, but it's an interesting idea. Maybe there's a way to move some of the registry injection code out of Bravo into its own reusable module.
