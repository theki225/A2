(define (domain DangeonPro)

    (:requirements :typing :negative-preconditions :disjunctive-preconditions :equality :conditional-effects
    )

    (:types
        swords cells heroes
    )

    (:predicates
        ;Hero's cell location
        (at-hero ?loc - cells ?hero - heroes)

        ;Sword cell location
        (at-sword ?s - swords ?loc - cells)

        ;Indicates if a cell location has a monster
        (has-monster ?loc - cells)

        ;Indicates if a cell location has a trap
        (has-trap ?loc - cells)

        ;Indicates if a chell or sword has been destroyed
        (is-destroyed ?obj)

        ;connects cells
        (connected ?from ?to - cells)

        ;Hero's hand is free
        (arm-free ?hero - heroes)

        ;Hero's holding a sword
        (holding ?s - swords ?hero - heroes)

        ;It becomes true when a trap is disarmed
        (trap-disarmed ?loc)

        ;A cell is occupied by a hero
        (occupied ?loc - cells)

        ;Check the current hero
        (check-hero ?hero - heroes)

        ;Turn relations for heroes
        (hero-turn ?heroA ?heroB - heroes)

        ;Hero and his/her own goal
        (hero-goal ?loc - cells ?hero - heroes)

        ;It becomes true when the hero reached his/her own goal
        (completed ?hero - heroes)

    )

    ;Hero can move if the
    ;    - hero is at current location
    ;    - cells are connected, 
    ;    - there is no trap in current loc, and 
    ;    - destination does not have a trap/monster/has-been-destroyed/occupied-by-other-heroes
    ;    - the previous hero and its following hero
    ;Effects 
    ;    - move the hero, 
    ;    - destroy the original cell, 
    ;    - change cells' occupation status,
    ;    - remove the previous hero record when only one hero is left. No need to destroy the sword.
    (:action move
        :parameters (?from ?to - cells ?pre ?current - heroes)
        :precondition (and
            (at-hero ?from ?current)
            (connected ?from ?to)
            (or (not (has-trap ?from)) (trap-disarmed ?from))
            (not (has-trap ?to))
            (not (has-monster ?to))
            (not (is-destroyed ?to))
            (not (occupied ?to))
            (check-hero ?pre)
            (hero-turn ?pre ?current)  
        )
        :effect (and
            (not (at-hero ?from ?current))
            (at-hero ?to ?current)
            (is-destroyed ?from)
            (occupied ?to)
            (not (occupied ?from))
            (when
                (not (= ?pre ?current))
                (and (check-hero ?current) (not (check-hero ?pre))))
        )
    )

    ;When this action is executed, the hero gets into a location with a trap
    (:action move-to-trap
        :parameters (?from ?to - cells ?pre ?current - heroes)
        :precondition (and
            (at-hero ?from ?current)
            (connected ?from ?to)
            (or (not (has-trap ?from)) (trap-disarmed ?from))
            (has-trap ?to)
            (not (is-destroyed ?to))
            (arm-free ?current)
            (check-hero ?pre)
            (hero-turn ?pre ?current)
            (not (occupied ?to))
        )
        :effect (and
            (not (at-hero ?from ?current))
            (at-hero ?to ?current)
            (is-destroyed ?from)
            (occupied ?to)
            (not (occupied ?from))
            (when
                (not (= ?pre ?current))
                (and (check-hero ?current) (not (check-hero ?pre))))
        )
    )

    ;When this action is executed, the hero gets into a location with a monster
    (:action move-to-monster
        :parameters (?from ?to - cells ?s - swords ?pre ?current - heroes)
        :precondition (and
            (at-hero ?from ?current)
            (connected ?from ?to)
            (or (not (has-trap ?from)) (trap-disarmed ?from))
            (has-monster ?to)
            (not (is-destroyed ?to))
            (holding ?s ?current)
            (check-hero ?pre)
            (hero-turn ?pre ?current)
            (not (occupied ?to))
        )
        :effect (and
            (not (at-hero ?from ?current))
            (at-hero ?to ?current)
            (is-destroyed ?from)
            (occupied ?to)
            (not (occupied ?from))
            (when
                (not (= ?pre ?current))
                (and (check-hero ?current) (not (check-hero ?pre))))
        )
    )

    ;Hero picks a sword if he's in the same location
    (:action pick-sword
        :parameters (?loc - cells ?s - swords ?pre ?current - heroes)
        :precondition (and
            (at-hero ?loc ?current)
            (at-sword ?s ?loc)
            (arm-free ?current)
            (check-hero ?pre)
            (hero-turn ?pre ?current)
        )
        :effect (and
            (holding ?s ?current)
            (not (arm-free ?current))
            (not (at-sword ?s ?loc))
            (when
                (not (= ?pre ?current))
                (and (check-hero ?current) (not (check-hero ?pre))))
        )
    )

    ;Hero destroys his sword. 
    (:action destroy-sword
        :parameters (?loc - cells ?s - swords ?pre ?current - heroes)
        :precondition (and
            (at-hero ?loc ?current)
            (holding ?s ?current)
            (not (has-monster ?loc))
            (not (has-trap ?loc))
            (check-hero ?pre)
            (hero-turn ?pre ?current)
        )
        :effect (and
            (not (holding ?s ?current))
            (arm-free ?current)
            (when
                (not (= ?pre ?current))
                (and (check-hero ?current) (not (check-hero ?pre))))
        )
    )

    ;Hero disarms the trap with his free arm
    (:action disarm-trap
        :parameters (?loc - cells ?pre ?current - heroes)
        :precondition (and
            (at-hero ?loc ?current)
            (has-trap ?loc)
            (not (trap-disarmed ?loc))
            (arm-free ?current)
            (check-hero ?pre)
            (hero-turn ?pre ?current)
        )
        :effect (and
            (trap-disarmed ?loc)
            (when
                (not (= ?pre ?current))
                (and (check-hero ?current) (not (check-hero ?pre))))
        )
    )

    ;Set the complete status of the hero to true when he/she reaches the goal separately.
    (:action reached-goal
        :parameters (?loc - cells ?pre ?current ?next - heroes)
        :precondition (and
            (at-hero ?loc ?current)
            (hero-goal ?loc ?current)
            (not (completed ?current))
            (check-hero ?pre)
            (hero-turn ?pre ?current)
            (hero-turn ?current ?next)
        )
        :effect (and
            (completed ?current)
            (when
                (not (= ?pre ?current))
                (and
                    (check-hero ?next)
                    (not (check-hero ?pre))
                    (hero-turn ?pre ?next)
                    (not (hero-turn ?pre ?current))
                    (not (hero-turn ?current ?next))
                ))
        )
    )

)