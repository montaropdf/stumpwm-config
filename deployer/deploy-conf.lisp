(require :asdf)
(require :quicklisp)

(ql:quickload :inferior-shell)
(ql:quickload :libconfig)

(asdf:load-system :reve-workshop)

(require :uiop)

(let ((stumpwm-conf-dir (reve-workshop.tools:merge-pathnames-to-string (uiop:xdg-config-home) "stumpwm"))
      (deployer-conf-path (reve-workshop.tools:merge-pathnames-to-string (uiop:xdg-config-home) "reve/deploy-conf.conf"))
      (files-to-copy '(autostart.lisp config customs.lisp equake-conf.lisp keybindings.lisp lisp-server.lisp)))
  (progn
    (print deployer-conf-path)
    (handler-case
        (libconfig:with-read-config-file deployer-conf-path
          (let ((src-stumpwm-dir (reve-workshop.tools:merge-pathnames-to-string
                                  (libconfig:read-setting "public-source-dir")
                                  "stumpwm")))
            (print src-stumpwm-dir)
            (ensure-directories-exist stumpwm-conf-dir)
            (print (eval `(inferior-shell:run/s '(progn
                                                  (cd ,src-stumpwm-dir)
                                                  (pwd)
                                                  (cp ,@files-to-copy ,stumpwm-conf-dir)))))))
      (libconfig:conf-file-read-error () (format t "Could not read config file.~%")))))
