;; -*-lisp-*-
;;
(in-package :stumpwm)

;; * Defining key bindings
;; Change the prefix key to something else
(set-prefix-key (kbd "s-z"))

;; * Redefinition of key bindings
(undefine-key *root-map* (kbd "C-w"))
(define-key *root-map* (kbd "C-w") "windowlist")

;; * Defining application key bindings
;; ** Define application menu
(defcommand firefox () ()
            "run firefox"
            (run-or-raise "firefox" '(:class "Firefox")))

(defcommand mattermost () ()
            "run mattermost"
            (run-or-raise "~/programmes/mattermost-desktop-latest/mattermost-desktop" '(:class "Mattermost")))

(defcommand revecloud-web () ()
            "Open the Proxmox web console of Revecloud"
            (run-or-raise "firefox -P 'Revecloud'" '(:class "Revecloud")))

;; (make-web-jump "google" "firefox http://www.google.fr/search?q=")

(setq *app-menu*
      '(("INTERNET"
         ;; submenu
         ("Firefox" firefox)       ; call stumpwm command
         ;; ("Skype" "skypeforlinux") ; run shell script
         )
        ("COMMS"
         ("Weechat" "weechat")
         ("Mattermost" mattermost);; /home/roland/programmes/mattermost-desktop-4.0.1/mattermost-desktop
         ("Email" "emacsclient -c -e '(mu4e)'")
         )
        ("MONITORING"
         ("Conky" "conky")
         ("Revecloud Web" revecloud-web))
        ("ADMINISTRATION"
         ("Configuration Emacs" "emacsclient -c -e '(dired ~/.personal/)'")
         ("Configuration StumpWM" "emacsclient -c -e '(dired ~/.config/stumpwm)'")
         )
        ("WORK"
         ("OpenOffice.org"  "openoffice"))
        ("GRAPHICS"
         ("GIMP" "gimp")
         ("Inkscape" "inkscape"))
        ("Terminal" "alacritty")))

(defvar *my-pass-menu*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "c") "pass-copy")
    (define-key m (kbd "m") "pass-copy-menu")
    (define-key m (kbd "g") "pass-generate")
    m ; NOTE: this is important
    ))

(defvar *my-application-menu*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "S") "exec /usr/bin/sparkleshare --status-icon=gtk")
    (define-key m (kbd "c") "exec alacritty -name weechat -e weechat")
    (define-key m (kbd "d") "exec evince")
    (define-key m (kbd "e") "colon1 exec emacsclient -c ")
    (define-key m (kbd "f") "exec firefox -P")
    (define-key m (kbd "C-s") "colon1 exec alacritty -t ssh -e ssh ")
    (define-key m (kbd "s") "surfraw")
    (define-key m (kbd "t") "exec alacritty")
    (define-key m (kbd "y") "exec alacritty -t youtube-viewer -e 'youtube-viewer -S --player mpv'")
    (define-key m (kbd "p") '*my-pass-menu*)
    (define-key m (kbd "s-q") "end-session")
    m ; NOTE: this is important
    ))

(define-key *top-map* (kbd "s-a") '*my-application-menu*)

;; Lock screen
(define-key *root-map* (kbd "C-l") "exec xlock")

(define-key *root-map* (kbd "C-y") "show-clipboard-history")

(define-key *root-map* (kbd "C-f") "show-menu")

;; Key binding for eQuake
(define-key *top-map* (kbd "F12") "invoke-equake")

;; Quick access to groups
(define-key *top-map* (kbd "s-F1") "gselect 1")
(define-key *top-map* (kbd "s-F2") "gselect 2")
(define-key *top-map* (kbd "s-F3") "gselect 3")
(define-key *top-map* (kbd "s-F4") "gselect 4")
(define-key *top-map* (kbd "s-F5") "gselect 5")

;; Quick frame navigation
(define-key *top-map* (kbd "s-Up") "move-focus up")
(define-key *top-map* (kbd "s-Down") "move-focus down")
(define-key *top-map* (kbd "s-Left") "move-focus left")
(define-key *top-map* (kbd "s-Right") "move-focus right")

;; Quick windows navigation in current frame
(define-key *top-map* (kbd "M-Tab") "pull-hidden-next")
(define-key *top-map* (kbd "M-ISO_Left_Tab") "pull-hidden-previous")

;; * Defining multimedia keys key binding
;; Sound volume management
(define-key *top-map* (kbd "XF86AudioLowerVolume") "amixer-Master-1-")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "amixer-Master-1+")
(define-key *top-map* (kbd "XF86AudioMute") "amixer-Master-toggle")

(which-key-mode)
;; start the polling timer process
(clipboard-history:start-clipboard-manager)
