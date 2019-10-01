(fn mprint [a b]
  (print (.. (tostring a) " " (tostring b))))

(fn main1 []
  (let [a :hello
        b? :world]
    (let [(a b?) (if (and true false)
                     (values :a :b)
                     (or nil false)
                     (values :c :d))]
      (mprint a b?))))

(fn main2 []
  (let [a :hello
        b? :world]
    (let [[a b?] (if (and true false)
                     [:a :b]
                     (or nil false)
                     [:c :d]
                     [a b?])]
      (mprint a b?))))

(fn main3 []
  (let [a :hello
        b :world]
    (let [(a b) (if (and true false)
                    (values :a :b)
                    (or nil false)
                    (values :c :d))]
      (mprint a b))))

(main1)  ; hello nil
(main2)  ; hello world
(main3)  ; hello world
