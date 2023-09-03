;It's recommended to install the misc-pddl-generators plugin 
;and then use Network generator to create the graph
(define (problem p4-dangeon)
  (:domain DangeonPro)
  (:objects
    cell1 cell2 cell3 cell4 cell5 cell6 cell7 cell8 cell9 cell10 cell11 cell12 cell13 cell14 cell15 cell16 - cells
    sword1 sword2 sword3 - swords
    hero1 hero2 hero3 - heroes
  )
  (:init

    ;Initial Hero Location
    (at-hero cell7 hero1)
    (at-hero cell7 hero2)
    (at-hero cell7 hero3)

    ;He starts with a free arm
    (arm-free hero1)
    (arm-free hero2)
    (arm-free hero3)

    ;Set hero's own goal
    (hero-goal cell1 hero1)
    (hero-goal cell2 hero2)
    (hero-goal cell13 hero3)

    ;Check the initial hero
    (check-hero hero1)

    ;Set play run order for heroes
    (hero-turn hero1 hero2)
    (hero-turn hero2 hero3)
    (hero-turn hero3 hero1)

    ;Initial location of the swords
    (at-sword sword1 cell10)
    (at-sword sword2 cell6)
    (at-sword sword3 cell15)

    ;Initial location of Monsters
    (has-monster cell4)
    (has-monster cell5)
    (has-monster cell14)

    ;Initial lcocation of Traps
    (has-trap cell3)
    (has-trap cell8)
    (has-trap cell11)
    (has-trap cell12)
    (has-trap cell16)

    ;Graph Connectivity
    (connected cell1 cell2)
    (connected cell2 cell1)
    (connected cell1 cell8)
    (connected cell8 cell1)

    (connected cell2 cell3)
    (connected cell3 cell2)
    (connected cell2 cell9)
    (connected cell9 cell2)
    (connected cell2 cell13)
    (connected cell13 cell2)

    (connected cell3 cell4)
    (connected cell4 cell3)
    (connected cell3 cell8)
    (connected cell8 cell3)
    (connected cell3 cell10)
    (connected cell10 cell3)

    (connected cell4 cell5)
    (connected cell5 cell4)
    (connected cell4 cell9)
    (connected cell9 cell4)
    (connected cell4 cell11)
    (connected cell11 cell4)

    (connected cell5 cell6)
    (connected cell6 cell5)
    (connected cell5 cell10)
    (connected cell10 cell5)
    (connected cell5 cell12)
    (connected cell12 cell5)

    (connected cell6 cell7)
    (connected cell7 cell6)
    (connected cell6 cell11)
    (connected cell11 cell6)

    (connected cell7 cell12)
    (connected cell12 cell7)
    (connected cell7 cell16)
    (connected cell16 cell7)

    (connected cell8 cell9)
    (connected cell9 cell8)

    (connected cell9 cell10)
    (connected cell10 cell9)

    (connected cell10 cell11)
    (connected cell11 cell10)

    (connected cell11 cell12)
    (connected cell12 cell11)

    (connected cell13 cell14)
    (connected cell14 cell13)

    (connected cell14 cell15)
    (connected cell15 cell14)

    (connected cell15 cell16)
    (connected cell16 cell15)
  )
  (:goal
    (and
      ;Hero's completed status
      (completed hero1)
      (completed hero2)
      (completed hero3)
    )
  )

)