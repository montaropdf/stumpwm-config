;; -*-lisp-*-
;;
(in-package :stumpwm)

;; * EQuake configuration
;; ** Define a new key map to manage the dedicated Emacs server
(defvar *equake-manager-menu* '((("Summon Cyber-daemon" "emacs --daemon=cyber-daemon -Q && emacsclient -e '(load-file \"~/.emacs.d/equake.el\")' -s 'cyber-daemon'")
                                 ("Banish Cyber-daemon" "emacsclient -e '(kill-emacs)' -s 'cyber-daemon'")
                                 ("Invoke console" invoke-equake))))

(defvar *equake-manager-map*
  (let ((m (stumpwm:make-sparse-keymap)))
    (stumpwm:define-key m (stumpwm:kbd "s") "exec emacs --daemon=cyber-daemon -Q")))




(defun calc-equake-width ()
  (let ((screen-width (caddr (with-input-from-string (s (run-shell-command "emacsclient -s 'cyber-daemon' -n -e '(equake-find-workarea-of-current-screen (equake-calculate-mouse-location (display-monitor-attributes-list)) (display-monitor-attributes-list))'" t)) (read s))))
        (desired-width-perc (read-from-string (run-shell-command "emacsclient -s 'cyber-daemon' -n -e 'equake-size-width'" t))))
    (truncate (* screen-width desired-width-perc))))

(defun calc-equake-height ()
  (let ((screen-height (cadddr (with-input-from-string (s (run-shell-command "emacsclient -n -e '(equake-find-workarea-of-current-screen (equake-calculate-mouse-location (display-monitor-attributes-list)) (display-monitor-attributes-list))'" t)) (read s))))
        (desired-height-perc (read-from-string (run-shell-command "emacsclient -s 'cyber-daemon' -n -e 'equake-size-height'" t))))
    (truncate (* screen-height desired-height-perc))))

(setq *equake-width* 800) ; TODO: programmatically get screen dimensions before Emacs starts
(setq *equake-height* 200)

(defcommand invoke-equake () ()
  (if (and (not (equal (current-window) 'nil)) (search "*EQUAKE*[" (window-name (current-window)))) ; If there is a current window and it is Equake,
      (progn (unfloat-window (current-window) (current-group))
             (hide-window (current-window))) ;; then hide Equake window via native Stumpwm method.
    (let ((found-equake (find-equake-globally (screen-groups (current-screen))))) ; Otherwise, search all groups of current screen for Equake window:
      (if (not found-equake)          ; If Equake cannot be found,
          (progn
            (run-shell-command "emacsclient -s 'cyber-daemon' -n -e '(equake-invoke)'") ; then invoke Equake via emacs function.
            ;; (setq *equake-height* (calc-equake-height)) ; delay calculation of height & width setting until 1st time equake invoked
            ;; (setq *equake-width* (calc-equake-width)) ; (otherwise Emacs may not be fully loaded)
            (setf screen-float-focus-color "Blue")
            (float-window found-equake (current-group)) ; float window
            (float-window-move-resize (find-equake-globally (screen-groups (current-screen))) :width *equake-width* :height *equake-height*))
        (progn
          (focus-window found-equake)
          (move-window-to-group found-equake (current-group)) ; But if Equake window is found, move it to the current group,
          (unhide-window found-equake) ; unhide window, in case hidden
          (float-window found-equake (current-group)) ; float window
          (float-window-move-resize (find-equake-globally (screen-groups (current-screen))) :width *equake-width* :height *equake-height*)))))) ; set size

(defun find-equake-in-group (windows-list) 
  "Search through WINDOWS-LIST, i.e. all windows of a group, for an Equake window. Sub-component of '#find-equake-globally."
  (let ((current-searched-window (car windows-list)))
    (if (equal current-searched-window 'nil)
        'nil
      (if (search "*EQUAKE*[" (window-name current-searched-window))
          current-searched-window
        (find-equake-in-group (cdr windows-list))))))

(defun find-equake-globally (group-list)
  "Recursively search through GROUP-LIST, a list of all groups on current screen, for an Equake window."
  (if (equal (car group-list) 'nil)
      'nil
    (let ((equake-window (find-equake-in-group (list-windows (car group-list)))))
      (if equake-window
          equake-window               ; stop if found and return window
        (find-equake-globally (cdr group-list))))))
