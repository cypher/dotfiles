(defproject global "0.0.0"
  :description "Don't rename this project, but you can change the version if you want."
  :dependencies [[clojure "1.2.0"]
                 [clojure-contrib "1.2.0"]])
;;--------------------
;; This is the global cake project. What does that mean?
;;  1. This project is used whenever you run cake outside a project directory.
;;  2. Any dependencies specified here will be available in the global repl.
;;  3. Any dev-dependencies specified here will be available in all projects, but
;;     you must run 'cake deps --global' manually when you change this file.
;;  4. Configuration options in ~/.cake/config are used in all projects.
;;--------------------
