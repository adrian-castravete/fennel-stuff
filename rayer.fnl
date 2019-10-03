(local fennel (require :fennel-lang.fennel))
(local fennel-view (require :fennel-lang.fennelview))
(local magick (require :magick))

(fn sanitize-scene [scene]
  (fn sanitize-objects [given]
    (fn sanitize-object [given]
      (let [{:position gp
             :rotation gr
             :scale gs
             :body gb} given]
        (when (not gb)
          (print (.. "Missing body function for object:\n" (fennel-view given)))
          (os.exit -1))
        {:position (or gp [0 0 0])
         :rotation (or gr [0 0 0])
         :scale (or gs [1 1 1])
         :body gb}))
    (let [given (or given [])
          objects []]
      (for [i 1 (# given)]
        (table.insert objects (sanitize-object (. given i))))
      objects))
  (fn sanitize-lights [given]
    (fn sanitize-light [given]
      (fn sanitize-kind [kind]
        (match kind
          :point :point
          :spot-light (do
                        (when (not given.lookat)
                          (print (.. "Missing lookat for spot-light:\n" (fennel-view given)))
                          (os.exit -1))
                        :spot-light)
          _ :point))
      (let [{:position gp
             :kind gk
             :length gl
             :lookat gla
             :power gpw
             :transform gt} given]
        {:position (or gp [-5 5 5])
         :kind (sanitize-kind gk)
         :length (or gl 10)
         :transform (or gt (fn [v] v))
         :power (or gpw 100)
         :lookat gla}))
    (let [given (or given [])
          lights []]
      (for [i 1 (# given)]
        (table.insert lights (sanitize-light (. given i))))
      lights))
  (fn sanitize-camera [given]
    (let [given (or given {})
          {:position gp
           :lookat gla
           :up gup
           :angle ga} given]
      {:position (or gp [0 0 10])
       :lookat (or gla [0 0 0])
       :up (or gup [0 1 0])
       :angle (or ga 60)}))
  (fn sanitize-size [given]
    (let [given (or given {})
          {:width w
           :height h} given]
      {:width (or w 320)
       :height (or h 200)}))
  {:objects (sanitize-objects scene.objects)
   :lights (sanitize-lights scene.lights)
   :camera (sanitize-camera scene.camera)
   :size (sanitize-size scene.size)})

(fn trace-image [scene]
  (print (fennel-view scene)))

(fn main [ray-file out-file]
  (let [out-file (or out-file "out.png")]
    (when ray-file
      (let [ray-scene (fennel.dofile ray-file)]
        (when (not ray-scene)
          (print "Missing scene.")
          (os.exit -1))
        (let [san-scene (sanitize-scene ray-scene)]
          (trace-image san-scene))))))

(main ...)
