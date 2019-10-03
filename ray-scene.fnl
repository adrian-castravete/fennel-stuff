(fn sphere-body [data])

(fn light-power [v] v)

{:objects [{:position [0 0 0]
            :rotation [0 0 0]
            :scale [1 1 1]
            :body sphere-body}]
 :lights [{:position [-5 5 8]
           :kind :point
           :length 20
           :power light-power}]}
