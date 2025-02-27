Koan subclass: TestBlock [
  <comment: 'A collection of block tests.'>

  testBlockCreation [
    | block anotherBlock |

    block := [].
    anotherBlock := BlockClosure new.

    self expect: BlockClosure toEqual: block class.
    self expect: BlockClosure toEqual: anotherBlock class.
  ]

  testSendingValueMessageExecutesBlocks [
    | block anotherBlock string |

    block := [ 'Smalltalk' ].

    self expect: 'Smalltalk' toEqual: block value.

    anotherBlock := [ string := 'Virtual Machine' ].
    anotherBlock value.

    self expect: 'Virtual Machine' toEqual: string.
  ]

  testBlocksReturnAnyKindOfValue [
    | block anotherBlock andAnotherBlock |

    block := [ 10 ].
    anotherBlock := [ #smalltalk ].
    andAnotherBlock := [ true ].

    self expect: 10 toEqual: block value.
    self expect: #smalltalk toEqual: anotherBlock value.
    self expect: true toEqual: andAnotherBlock value.
  ]

  testPassingArgumentsToBlocks [
    | block |

    block := [ :argOne :argTwo | argOne, ' and ', argTwo ].

    self expect: 'Alan and Dan' toEqual: (block value: 'Alan' value: 'Dan').
  ]

  testBlockArgumentLimit [
    | block |

    block := [ :x :y :z | x + y * z ].

    self expect: 36 toEqual: (block value: 10 value: 2 value: 3).
    "Blocks accept between zero up to 3 separate arguments."
  ]

  testPassingMoreThanThreeArguments [
    | block |

    block := [ :a :b :c :d :e | a + b + c + d + e ].

    self expect: 30 toEqual: (block valueWithArguments: #(2 4 6 8 10)).
  ]

  testPassingMoreArgumentsThanExpected [
    | block |

    block := [ :x | x ].

    self expect: [ block value: 1 value: 2 ] toRaise: SystemExceptions.WrongArgumentCount.
  ]

  testIterateUsingInterval [
    | counter |

    counter := 0.
    1 to: 5 do: [ :n | counter := counter + n ].

    self expect: 15 toEqual: counter.

    counter := 0.
    1 to: 10 by: 2 do: [ :n | counter := counter + n ].

    self expect: 25 toEqual: counter.
  ]

  testClosure [
    | value block |

    value := 10.
    block := [ :number | number + value ].

    self expect: 30 toEqual: (block value: 20).
  ]

  testRealClosure [
    | counter block |

    counter := 1.

    block := [
      | variable |

      variable isNil ifTrue: [ variable := counter ].
      counter := counter + 1.
      variable.
    ].

    self expect: 1 toEqual: block value.
    self expect: 2 toEqual: block value.
    self expect: 3 toEqual: block value.
  ]

  testCull [
    | block |

    block := [].

    self expect: nil toEqual: (block cull: 1).
    self expect: [ block value: 1 ] toRaise:
    SystemExceptions.WrongArgumentCount.
  ]

  testEachBlockIsAUniqueObject [
    self expect: false toEqual: ([] hash = [] hash).
  ]
]
