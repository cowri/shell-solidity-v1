# Shell tests

## Suites 
The tests are divided into suites. Suites are composed asset sets and parameter sets. Asset sets are the numeraires, reserves and weights for the tokens in the pool, which entails a set of assimilators. Parameter sets are the global variables to use in the pool.

* Suite One:
    * Assimilator Set One
    * Asset Set One
    * Param Set One

* Suite Two:
    * Assimilator Set One
    * Asset Set One
    * Param Set Two

* Suite Three:
    * Assimilator Set Two
    * Asset Set Two
    * Param Set One

* Suite Four:
    * Assimilator Set Two
    * Asset Set Two
    * Param Set Two

* Suite Five - monotonicity tests:
    * Assimilator Set One
    * Asset Set One
    * Param Set Four

* Suite Six - continuity tests:
    * Assimilator Set One
    * Asset Set One
    * Param Set Three

* Suite Seven - real life:
    * Assimilator Set One
    * Asset Set One
    * Param Set Five
    
### Pool Parameter Sets

*   Set One - standard testing with 2.5 bps base fee:
    * alpha = .5e18;
    * beta = .25e18;
    * max = .5e18;
    * epsilon = 2.5e14;
    * lambda = .2e18;

*   Set Two - standard testing with 5bps base fee:
    * alpha = .5e18;
    * beta = .25e18;
    * max = .05e18;
    * epsilon = 5e14;
    * lambda = .2e18;

*   Set Three - continuity tests 100% lambda 0% base fee:
    * alpha = .5e18;
    * beta = .25e18;
    * max = .05e18;
    * epsilon = 0;
    * lambda = 1e18;

*  Set Four - monotonicity checks:
    * alpha = .5e18;
    * beta = .48e18;
    * max = .49e18;
    * epsilon = 2.5e14;
    * lambda = .2e18;

* Set Five:
    * alpha = .9e18;
    * beta = .4e18;
    * max = .05e18;
    * epsilon = 3.5e14;
    * lambda = .5e18;

### Pool Asset Sets

* Set One:
    * Assimilator Set One
    * 30% dai
    * 30% usdc
    * 30% usdt
    * 10% susd

*  Set Two:
    * Assimillator Set Two
    * 30% dai
    * 30% usdc
    * 30% usdt
    * 10% susd

*  Set Three:
    * Assimilator Set One
    * 33.3% dai
    * 33.3% usdc
    * 33.3% usdt

*  Set Four:
    * Assimilator Set Two
    * 33.3% dai
    * 33.3% usdc
    * 33.3% usdt


### Assimilator Sets

* Set One:
    * dai reserves held in dai
    * usdc reserves held in usdc
    * usdt reserves held in usdt
    * susd reserves held in susd

* Set Two: 
    * dai reserves held in cdai
    * usdc reserves held in cusdc
    * usdt reserves held in ausdt
    * susd reserves held in asusd