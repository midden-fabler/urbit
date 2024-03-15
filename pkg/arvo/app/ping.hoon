::  Ping our sponsorship tree regularly for routing.
::
::  To traverse NAT, we need the response to come back from someone
::  we've sent a message to.  We ping our sponsor so that they know
::  where we are.  However, we also need to ping our galaxy because if
::  the other ship tries to respond directly, it may be blocked by our
::  firewall or NAT.  Thus, the response must come from a ship we've
::  messaged directly, and the only one we can guarantee is our galaxy.
::  Note this issue manifests itself even for bootstrapping a planet to
::  talk to its own star.
::
/+  default-agent, verb, dbug
=*  point  point:kale
::
|%
::  How often to ping our sponsor when we might be behind a NAT.
::
::    NAT timeouts are often pretty short for UDP entries.  5 minutes is
::    a common value.  We use 25 seconds, same as Wireguard.
::
++  nat-timeout  ~s25
::
+$  card  card:agent:gall
::
+$  state-2
  $:  %2
      ships=(set ship)
      nonce=@ud
      $=  plan
      $~  [%nat ~]
      $%  [%nat ~]
          [%pub ip=(unit @t)]
          [%off ~]
          [%one ~]
      ==
  ==
+$  state-3
  $:  %3
     mode=?(%formal %informal)
     sent=?
     galaxy=@p
  ==
--
::
%-  agent:dbug
::
=|  state=state-3
=>  |%
  ++  galaxy-for
    |=  [=ship =bowl:gall]
    ^-  @p
    =/  next  (sein:title [our now our]:bowl)
    ?:  ?=(%czar (clan:title next))
      next
    $(ship next)
  ::
  ++  wait-card
    |=  now=@da
    ^-  card
    [%pass /wait %arvo %b %wait (add nat-timeout now)]
  ::
  ++  ping
    |=  =ship
    ^-  (quip card _state)
    ?:  &(sent.state =(ship galaxy.state))
      [~ state]
    :_  state(sent %.y, galaxy ship)
    [%pass /ping/(scot %p ship) %agent [ship %ping] %poke %noun !>(~)]~
--
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
::
::  +on-init: initializing on startup
::
++  on-init
  ^-  [(list card) _this]
  =.  mode.state    %formal
  =.  sent.state    %.n
  =.  galaxy.state  (galaxy-for our.bowl bowl)
  [~ this]
::
++  on-load
  |=  old-vase=vase
  |^
  =/  old  !<(state-any old-vase)
  =?  old  ?=(%0 -.old)  (state-0-to-1 old)
  =?  old  ?=(%1 -.old)  (state-1-to-2 old)
  =?  old  ?=(%2 -.old)  (state-2-to-3 old)
  ?>  ?=(%3 -.old)
  =.  state  old
  [~ this]
  ::
  +$  ship-state
    $%  [%idle ~]
        [%poking ~]
        [%http until=@da]
        [%waiting until=@da]
    ==
  +$  state-any  $%(state-0 state-1 state-2 state-3)
  +$  state-0    [%0 ships=(map ship [=rift =ship-state])]
  +$  state-1
    $:  %1
        ships=(set ship)
        nonce=@ud
        $=  plan
        $~  [%nat ~]
        $%  [%nat ~]
            [%pub ip=(unit @t)]
    ==  ==
  ::
  ++  state-0-to-1
    |=  old=state-0
    ^-  state-1
    [%1 ~ 0 %nat ~]
  ::
  ++  state-1-to-2
    |=  old=state-1
    ^-  state-2
    old(- %2)
  ::
  ++  state-2-to-3
    |=  old=state-2
    ^-  state-3
    [%3 %formal %.n (galaxy-for our.bowl bowl)]
  --
::  +on-poke: positively acknowledge pokes
::
++  on-poke
  |=  [=mark =vase]
  ?.  =(our src):bowl    :: don't crash, this is where pings are handled
    `this
  ::
  =^  cards  state
    ?:  ?=([%kick ?] q.vase)
      =?  mode.state  =(+.q.vase %.y)
        %formal
      (ping (galaxy-for our.bowl bowl))
    ::
    ?:  |(=(q.vase %once) =(q.vase %stop))  :: NB: ames calls this on %once
      =.  mode.state  %informal
      (ping (galaxy-for our.bowl bowl))
    `state
  [cards this]
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ``noun+!>(state)
::  +on-agent: handle ames ack
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  [(list card) _this]
  ?.  ?=([%ping s=@ *] wire)
    `this
  ?.  =(galaxy.state (slav %p i.t.wire))
    `this
  =.  sent.state  %.n
  ?.  ?=(%formal mode.state)  `this
  [[(wait-card now.bowl)]~ this]
::  +on-arvo: handle timer firing
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  [(list card) _this]
  =^  cards  state
    ?+    wire  `state
        [%wait *]
      ?.  ?=(%formal mode.state)  `state
      ?>  ?=(%wake +<.sign-arvo)
      ?^  error.sign-arvo
        %-  (slog 'ping: strange wake fail!' u.error.sign-arvo)
        `state
      (ping (galaxy-for our.bowl bowl))
    ::
    ==
  [cards this]
::
++  on-save   !>(state)
++  on-fail   on-fail:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
--
