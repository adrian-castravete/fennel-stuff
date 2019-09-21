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

(fn generate-greys []
  (let [pal []]
    (for [i 0 255]
      (let [v (/ i 255)]
        (table.insert pal [v v v])))
    pal))

(let [pal (generate-greys)]
  (write-palette "greys.pal" pal))
