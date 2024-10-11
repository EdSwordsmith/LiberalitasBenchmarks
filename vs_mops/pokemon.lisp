(defclass pokemontype () ())

(defclass fire (pokemontype) ())
(defclass water (pokemontype) ())
(defclass grass (pokemontype) ())
(defclass electric (pokemontype) ())
(defclass normal (pokemontype) ())
(defclass ice (pokemontype) ())
(defclass fighting (pokemontype) ())
(defclass poison (pokemontype) ())
(defclass ground (pokemontype) ())
(defclass flying (pokemontype) ())
(defclass psychic (pokemontype) ())
(defclass bug (pokemontype) ())
(defclass rock (pokemontype) ())
(defclass ghost (pokemontype) ())
(defclass dragon (pokemontype) ())

(defclass pokemon () ())
(defclass lotad (pokemon water grass) ())
(defclass charmander (pokemon fire) ())
(defclass gastly (pokemon ghost) ())

(defmethod attack-mult ((attack pokemontype) (pokemon pokemon)) 1.0)

;; Normal attacks
(defmethod attack-mult :around ((attack normal) (pokemon rock)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack normal) (pokemon ghost)) 0.0)

;; fire attacks
(defmethod attack-mult :around ((attack fire) (pokemon fire)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack fire) (pokemon water)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack fire) (pokemon grass)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack fire) (pokemon ice)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack fire) (pokemon bug)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack fire) (pokemon rock)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack fire) (pokemon dragon)) (* 0.5 (call-next-method)))

;; water attacks
(defmethod attack-mult :around ((attack water) (pokemon fire)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack water) (pokemon water)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack water) (pokemon grass)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack water) (pokemon ground)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack water) (pokemon rock)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack water) (pokemon dragon)) (* 0.5 (call-next-method)))

;; electric attacks
(defmethod attack-mult :around ((attack electric) (pokemon water)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack electric) (pokemon electric)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack electric) (pokemon grass)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack electric) (pokemon ground)) 0.0)
(defmethod attack-mult :around ((attack electric) (pokemon flying)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack electric) (pokemon dragon)) (* 0.5 (call-next-method)))

;; grass attacks
(defmethod attack-mult :around ((attack grass) (pokemon fire)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack grass) (pokemon water)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack grass) (pokemon grass)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack grass) (pokemon poison)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack grass) (pokemon ground)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack grass) (pokemon flying)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack grass) (pokemon bug)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack grass) (pokemon rock)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack grass) (pokemon dragon)) (* 0.5 (call-next-method)))

;; ice attacks
(defmethod attack-mult :around ((attack ice) (pokemon water)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack ice) (pokemon grass)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack ice) (pokemon ice)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack ice) (pokemon ground)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack ice) (pokemon flying)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack ice) (pokemon dragon)) (* 2.0 (call-next-method)))

;; fighting attacks
(defmethod attack-mult :around ((attack fighting) (pokemon normal)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack fighting) (pokemon ice)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack fighting) (pokemon poison)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack fighting) (pokemon flying)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack fighting) (pokemon psychic)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack fighting) (pokemon bug)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack fighting) (pokemon rock)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack fighting) (pokemon ghost)) 0.0)

;; poison attacks
(defmethod attack-mult :around ((attack poison) (pokemon grass)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack poison) (pokemon poison)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack poison) (pokemon ground)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack poison) (pokemon bug)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack poison) (pokemon rock)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack poison) (pokemon ghost)) (* 0.5 (call-next-method)))

;; ground attacks
(defmethod attack-mult :around ((attack ground) (pokemon fire)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack ground) (pokemon electric)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack ground) (pokemon grass)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack ground) (pokemon poison)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack ground) (pokemon flying)) 0.0)
(defmethod attack-mult :around ((attack ground) (pokemon bug)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack ground) (pokemon rock)) (* 2.0 (call-next-method)))

;; flying attacks
(defmethod attack-mult :around ((attack flying) (pokemon electric)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack flying) (pokemon grass)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack flying) (pokemon fighting)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack flying) (pokemon bug)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack flying) (pokemon rock)) (* 0.5 (call-next-method)))

;; psychic attacks
(defmethod attack-mult :around ((attack psychic) (pokemon fighting)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack psychic) (pokemon poison)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack psychic) (pokemon psychic)) (* 0.5 (call-next-method)))

;; bug attacks
(defmethod attack-mult :around ((attack bug) (pokemon fire)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack bug) (pokemon grass)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack bug) (pokemon fighting)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack bug) (pokemon poison)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack bug) (pokemon flying)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack bug) (pokemon psychic)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack bug) (pokemon ghost)) (* 0.5 (call-next-method)))

;; rock attacks
(defmethod attack-mult :around ((attack rock) (pokemon fire)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack rock) (pokemon ice)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack rock) (pokemon fighting)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack rock) (pokemon ground)) (* 0.5 (call-next-method)))
(defmethod attack-mult :around ((attack rock) (pokemon flying)) (* 2.0 (call-next-method)))
(defmethod attack-mult :around ((attack rock) (pokemon bug)) (* 2.0 (call-next-method)))

;; ghost attacks
(defmethod attack-mult :around ((attack ghost) (pokemon normal)) 0.0)
(defmethod attack-mult :around ((attack ghost) (pokemon psychic)) 0.0)
(defmethod attack-mult :around ((attack ghost) (pokemon ghost)) (* 2.0 (call-next-method)))

;; dragon attacks
(defmethod attack-mult :around ((attack dragon) (pokemon dragon)) (* 2.0 (call-next-method)))

;; benchmarking
(defun benchmark-this (n water-gun charmander)
  (dotimes (i n)
    (attack-mult water-gun charmander)))

(ql:quickload "trivial-benchmark")

(let ((charmander (make-instance 'charmander))
      (water-gun (make-instance 'water)))
  (trivial-benchmark:with-timing (1000)
    (benchmark-this 1 water-gun charmander))
  (trivial-benchmark:with-timing (1000)
    (benchmark-this 20000 water-gun charmander))
  (trivial-benchmark:with-timing (1000)
    (benchmark-this 40000 water-gun charmander))
  (trivial-benchmark:with-timing (1000)
    (benchmark-this 60000 water-gun charmander))
  (trivial-benchmark:with-timing (1000)
    (benchmark-this 80000 water-gun charmander))
  (trivial-benchmark:with-timing (1000)
    (benchmark-this 100000 water-gun charmander)))
