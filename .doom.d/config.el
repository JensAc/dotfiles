;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq +doom-dashboard-banner-dir "~/.doom.d/")
(setq +doom-dashboard-banner-file "logo.png")

;;cutomize the modeline
(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar window-number modals matches buffer-info-simple remote-host buffer-position selection-info)
    '(objed-state misc-info persp-name irc mu4e github debug input-method lsp major-mode process vcs checker))
  (setq doom-modeline-bar-width 6))
