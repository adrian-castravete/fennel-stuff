(local fennel-view (require "fennel-lang.fennelview"))

(fn map [func coll]
  (let [lcoll (# coll)
        out []]
    (for [i 1 lcoll]
      (table.insert out (func (. coll i))))
    out))

(fn write-palette [file-name palette]
  (let [f (assert (io.open file-name :w))]
    (fn write-line [colour]
      (let [[r g b] colour
            ir (math.floor (* 255 r))
            ig (math.floor (* 255 g))
            ib (math.floor (* 255 b))]
        (f:write (.. "\n" ir " " ig " " ib))))
    (f:write "JASC-PAL\n0100\n256")
    (map write-line palette)
    (f:close)))

(fn write-pal-fn [file-name pal-fn]
  (let [pal (pal-fn)]
    (write-palette file-name pal)))

(fn gen-greys []
  (let [pal []]
    (for [i 0 255]
      (let [v (/ i 255)]
        (table.insert pal [v v v])))
    pal))

(fn hsv2rgb [hue sat val]
  (fn svi [v]
    (* (- 1 (* sat (- 1 v))) val))
  (let [h (* hue 6)
        sector (math.floor h)
        value (- h sector)
        nvalue (- 1 value)
        [r g b] (if (= sector 0)
                    [1 value 0]
                    (= sector 1)
                    [nvalue 1 0]
                    (= sector 2)
                    [0 1 value]
                    (= sector 3)
                    [0 nvalue 1]
                    (= sector 4)
                    [value 0 1]
                    (= sector 5)
                    [1 0 nvalue]
                    [1 0 0])]
    (values (svi r) (svi g) (svi b))))

(fn hsa2rgb [hue value]
  (if (<= value 1)
      (hsv2rgb hue 1 value)
      (hsv2rgb hue (- 2 value) 1)))

(fn gen-rainbow []
  (let [pal []]
    (for [i 0 255]
      (let [(r g b) (hsv2rgb (/ i 255) 1 1)]
        (table.insert pal [r g b])))
    pal))

(fn gen-cool-palette []
  (fn sat-val [v]
    (let [v (- 1 v)]
      (* 2 (- 1 (* v v)))))
  (let [a (/ 1 3)
        b (/ 2 3)
        pal [[0 0 0] [0 0 b] [0 b 0] [0 b b]
             [b 0 0] [b 0 b] [b a 0] [b b b]
             [a a a] [a a 1] [a 1 a] [a 1 1]
             [1 a a] [1 a 1] [1 1 a] [1 1 1]]]
    (for [j 0 11]
      (for [i 1 8]
        (table.insert pal [(hsa2rgb (/ j 12) (/ i 4.5))])))
    (for [j 0 11]
      (for [i 1 8]
        (table.insert pal [(hsa2rgb (/ j 12) (sat-val (/ i 9)))])))
    (while (< (# pal) 256)
      (table.insert pal [0 0 0]))
    pal))

(write-pal-fn "greys.pal" gen-greys)
(write-pal-fn "rainbow.pal" gen-rainbow)
(write-pal-fn "cool.pal" gen-cool-palette)
