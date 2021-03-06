;; -*-lisp-*-
;;
(in-package :stumpwm)

;; Prompt the user for an interactive command. The first arg is an
;; optional initial contents.
(defcommand colon1 (&optional (initial "")) (:rest)
            (let ((cmd (read-one-line (current-screen) ": " :initial-input initial)))
              (when cmd
                (eval-command cmd t))))

;; Web jump (works for Google and Imdb)
(defmacro make-web-jump (name prefix)
  `(defcommand ,(intern name) (search) ((:rest ,(concatenate 'string name " search: ")))
               (substitute #\+ #\Space search)
               (run-shell-command (concatenate 'string ,prefix search))))


;; Message window font
(load-module "ttf-fonts")
;; Next line to be used when fonts gets updated
;; (xft:cache-fonts)
(set-font (make-instance 'xft:font :family "DejaVu Sans Mono" :subfamily "Book" :size 14))

;; * Defining groups
;; (grename "Main")
(gnew "F2-Comms")
(gnew "F3-Media")
(gnew "F4-Admin")
(gnew "F5-Monitor")
;; (run-commands "gselect 1
;; grename F1-Main")

;; * Define windows placement policy
;; Clear rules
(clear-window-placement-rules)

;; Last rule to match takes precedence!
;; TIP: if the argument to :title or :role begins with an ellipsis, a substring
;; match is performed.
;; TIP: if the :create flag is set then a missing group will be created and
;; restored from *data-dir*/create file.
;; TIP: if the :restore flag is set then group dump is restored even for an
;; existing group using *data-dir*/restore file.
;; (define-frame-preference "F1-Main"
;;     ;; frame raise lock (lock AND raise == jumpto)
;;     (0 t nil :class "Konqueror" :role "...konqueror-mainwindow")
;;   (1 t nil :class "urxvt"))

(define-frame-preference "F3-Media"
    (0 t nil :class "mpv")
  (1 t nil :class "urxvt" :title "youtube-viewer"))

(define-frame-preference "F2-Comms"
    (0 nil t :create t :class "Mattermost")
  (1 t nil :title "...weechat"))

(define-frame-preference "F5-Monitor"
    (0 nil t :create t :class "Conky")
  (1 t nil :class "conky-manager"))

(define-frame-preference "F4-Admin"
    (0 nil t :create t :title "ssh"))



;; (define-frame-preference "Ardour"
;;     ;;   (0 t   t   :instance "ardour_editor" :type :normal)
;;     ;; (0 t   t   :title "Ardour - Session Control")
;;     (0 nil nil :class "urxvt")
;;   (1 t   nil :type :normal)
;;   (1 t   t   :instance "ardour_mixer")
;;   (2 t   t   :instance "jvmetro")
;;   (1 t   t   :instance "qjackctl")
;;   (3 t   t   :instance "qjackctl" :role "qjackctlMainForm"))

;; Mode line definition
(setf *mode-line-foreground-color* "gainsboro")
(setf *mode-line-background-color* "DeepSkyBlue")
(setf *mode-line-pad-y* 0)
(setf *mode-line-pad-x* 0)
(setf *mode-line-border-color* *mode-line-background-color*)
(setf *time-modeline-string* "%a %Y-%m-%e %k:%M")

(defvar group-item-format "^(:fg MediumSpringGreen)^(:bg black)[%n]")
(defvar focused-window-item-format "^(:fg gainsboro)^(:bg black)%w")
(defvar group-window-separator-format "^(:fg OrangeRed)^(:bg black)>>")
(defvar left-block-end-separator-format "^(:fg gainsboro)^(:bg black)|*\\")
(defvar right-block-begin-separator-format "^(:fg gainsboro)^(:bg black)/*|")
(defvar systray-block-begin-separator-format left-block-end-separator-format)
(defvar item-separator-format "^(:fg gainsboro)^(:bg black)|")
(defvar systray-block-format "^(:fg gainsboro)^(:bg black)%T")
(defvar battery-item-format "^(:fg gainsboro)^(:bg black)Battery: %B")
(defvar wifi-item-format "^(:fg gainsboro)^(:bg black)%I")
(defvar date-time-item-format "^(:fg gainsboro)^(:bg black)%d")

(setf stumpwm:*screen-mode-line-format*
      (list group-item-format
            "^n"
            group-window-separator-format
            "^n"
            focused-window-item-format
            "^n"
            left-block-end-separator-format
            "^n"
            "^>"
            right-block-begin-separator-format
            "^n"
            battery-item-format
            "^n"
            item-separator-format
            "^n"
            wifi-item-format
            "^n"
            item-separator-format
            "^n"
            date-time-item-format
            "^n"
            systray-block-begin-separator-format
            "^n"
            systray-block-format))


;; (setf stumpwm:*screen-mode-line-format*
;;       (list "^(:fg MediumSpringGreen :bg black)[%n]^n>>%w|*\\^(:bg MediumSpringGreen) ^>/*|Bat: %B|%I|%d|*\\%T"))

;; * StumpWM Menu tests
(defvar *reve-test-menu* '((("element 1" "emacs --daemon=cyber-daemon -Q && emacsclient -e '(load-file \"~/.emacs.d/equake.el\")' -s 'cyber-daemon'")
                            ("Banish Cyber-daemon" "emacsclient -e '(kill-emacs)' -s 'cyber-daemon'")
                            ("Invoke console" invoke-equake))))

(setf stumpwm:*input-window-gravity* :center)
(setf stumpwm:*message-window-gravity* :bottom-right)

(set-bg-color "gray18")

(set-focus-color "MediumSpringGreen")

(setf *normal-border-width* 6)
(setf *window-border-style* :TIGHT)


;; Set the mouse focus policy to :ignore
;; (setf *mouse-focus-policy* :ignore) ;; otherwise Equake will tend to disappear

