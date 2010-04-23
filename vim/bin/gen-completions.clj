; Copyright (c) 2006 Parth Malwankar
; All rights reserved.
;
; A small script to generate a dictionary of Clojure's core
; functions. The script was written by Parth Malwankar. It
; is included in VimClojure with his permission.
;  -- Meikel Brandmeyer, 16 August 2008
;     Frankfurt am Main, Germany
;
; See also: http://en.wikibooks.org/wiki/Clojure_Programming
;
(defmacro with-out-file [pathname & body]
  `(with-open stream# (new java.io.FileWriter ~pathname)
     (binding [*out* stream#]
       ~@body)))

(def completions (keys (ns-publics (find-ns 'clojure))))

(with-out-file "clj-keys.txt"
  (doseq x completions
    (println x)))
