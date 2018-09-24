#!/usr/local/bin/ispl
(progn
  (source lib)
  (set 'sgr (lambda '(n) '(print '[ n 'm)))
  (set 'cursor (lambda '(x y) '(print '[ (+ y 1) '";" (+ x 1) 'H)))
  (set 'cls (lambda nil '(print '[2J)))
  (set 'draw (lambda '(a) '(progn (sgr (car (cdr a))) (print (car a)))))

  (set 'grass '("'" "," "."))
  (set 'grass_colors '(32 92))
  (set 'width 80)
  (set 'height 24)
  (set 'area (* width height))
  (set 'zone (array area))

  (tick)
  (cls)
  (for '(set 'i 0) '(< i area) '(set 'i (+ i 1))
       '(progn (aset zone i (list (randelt grass) (randelt grass_colors)))
	       (cursor (mod i width) (/ i width))
	       (draw (aget zone i))))
  (cursor 80 24)
  (draw '(@ 32))
  (sgr 0)
  (print \n (tock) \n)
  )
