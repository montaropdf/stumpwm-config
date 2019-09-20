;;; Management of the swank server for emacs to operate StumpWM

(ql:quickload :swank)
(swank:create-server :port 4005 :dont-close t)
