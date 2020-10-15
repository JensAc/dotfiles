;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq +doom-dashboard-banner-dir "~/.doom.d/")
(setq +doom-dashboard-banner-file "logo.png")

(setq doom-theme 'doom-solarized-dark)

;;cutomize the modeline
(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar window-number modals matches buffer-info-simple remote-host buffer-position selection-info)
    '(objed-state misc-info persp-name irc mu4e github debug input-method lsp major-mode process vcs checker))
  (setq doom-modeline-bar-width 6))

(require 'smtpmail)

; smtp
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("mail.example.com" 587 nil nil))
      smtpmail-default-smtp-server "posteo.de"
      smtpmail-smtp-server "posteo.de"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(after! mu4e
  (require 'mu4e)

  (setq mu4e-maildir (expand-file-name "~/email/posteo"))

  (setq mu4e-drafts-folder "/Drafts")
  (setq mu4e-sent-folder   "/Sent Items")
  (setq mu4e-trash-folder  "/Trash")
  (setq message-signature-file "~/.emacs.d/.signature") ; put your signature in this file

                                        ; get mail
  (setq mu4e-get-mail-command "mbsync -c ~/.emacs.d/mu4e/.mbsyncrc -a"
        mu4e-html2text-command "w3m -T text/html"
        mu4e-update-interval 120
        mu4e-headers-auto-update t
        mu4e-compose-signature-auto-include nil)

  (setq mu4e-maildir-shortcuts
        '( ("/INBOX"               . ?i)
           ("/Sent Items"   . ?s)
           ("/Trash"       . ?t)
           ("/Drafts"    . ?d)))

  ;; show images
  (setq mu4e-show-images t)

  ;; use imagemagick, if available
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

  ;; general emacs mail settings; used when composing e-mail
  ;; the non-mu4e-* stuff is inherited from emacs/message-mode
  (setq mu4e-reply-to-address "jens.schneider.ac@posteo.de"
        user-mail-address "jens.schneider.ac@posteo.de"
        user-full-name  "Jens Schneider")

  ;; don't save message to Sent Messages, IMAP takes care of this
                                        ; (setq mu4e-sent-messages-behavior 'delete)

  ;; spell check
  (add-hook 'mu4e-compose-mode-hook
            (defun my-do-compose-stuff ()
              "My settings for message composition."
              (set-fill-column 72)
              (flyspell-mode))))


;; org-caldav
;;  (setq org-caldav-url "https://nextcloud.saturnv.de/remote.php/dav/calendars/jens")
;;  (setq org-caldav-calendar-id "personal")
;;  (setq org-caldav-inbox "~/org/calendar.org")

;;  (setq org-caldav-url "https://mattermost.ient.rwth-aachen.de:80/users")
;;  (setq org-caldav-calendar-id "schneider@ient.rwth-aachen.de/calendar")
  (setq org-caldav-uuid-extension ".EML")
;;  (setq org-caldav-inbox "~/org/calendar.org")

  (setq org-caldav-calendars
    '((:url "https://mattermost.ient.rwth-aachen.de:80/users/"
       :calendar-id "schneider@ient.rwth-aachen.de/calendar"
       :inbox "~/org/private_institute_calendar.org"
       :sync-direction cal->org
       )
     )
   )


;; org-calendar
  (require 'calfw-org)

