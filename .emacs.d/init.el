;; Many thanks to @daviwil (https://github.com/daviwil)
;; This config is mainly based on your streams and examples and is expected to evolve...

;; Basic UI Configuration ------------------------------------------------------

;; You will most likely need to adjust this font size for your system!
(defvar acemacs/default-font-size 100)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
		treemacs-mode-hook
                shell-mode-hook
		mu4e-headers-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Font Configuration ----------------------------------------------------------

(set-face-attribute 'default nil :font "Fira Code Retina" :height acemacs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height acemacs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height acemacs/default-font-size :weight 'regular)

;; Package Manager Configuration -----------------------------------------------

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Ivy Configuration -----------------------------------------------------------

(use-package ivy
  :diminish
  :bind (("C-s" . swiper))
  :config
  (ivy-mode 1))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; use smex such that recent commands are listed first when hitting M-x
(use-package smex)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-switch-buffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Key Binding Configuration ---------------------------------------------------

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-fine-undo t)
  :custom
  (evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)

  ;; some keybindings for evil. Note that arrow keys are easily accessible on the UHK
  (evil-global-set-key 'motion (kbd "<down>") 'evil-next-visual-line)
  (evil-global-set-key 'motion (kbd "<up>") 'evil-previous-visual-line)
  (evil-global-set-key 'normal (kbd "C-w <down>") 'evil-window-down) 
  (evil-global-set-key 'normal (kbd "C-w <up>") 'evil-window-up) 
  (evil-global-set-key 'normal (kbd "C-w <left>") 'evil-window-left) 
  (evil-global-set-key 'normal (kbd "C-w <right>") 'evil-window-right)) 
		    
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; uncomment when you are ready to set it up and use it
;;(use-package hydra)

;; Projectile Configuration ----------------------------------------------------

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
)

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; set pass as standard authentication method
(use-package auth-source-pass
  :config
  (setq auth-sources '(password-store)))

;; mu4e configuration so far only posteo account
(require 'mu4e)
(setq message-send-mail-function 'smtpmail-send-it
      user-full-name "Jens Schneider" )
(setq mu4e-contexts
    `( ,(make-mu4e-context
	  :name "Posteo"
	  :enter-func (lambda () (mu4e-message "Entering Posteo context"))
          :leave-func (lambda () (mu4e-message "Leaving Posteo context"))
	  ;; we match based on the contact-fields of the message
	  :match-func (lambda (msg)
			(when msg
			  (mu4e-message-contact-field-matches msg
			    :to "jens.schneider.ac@posteo.de")))
	  :vars '( ( user-mail-address	   . "jens.schneider.ac@posteo.de"  )
		   ( mu4e-sent-folder      . "/posteo/Sent" )
		   ( mu4e-trash-folder     . "/posteo/Trash" )
		   ( mu4e-drafts-folder    . "/posteo/Drafts" )
 		   ( smtpmail-smtp-user    . "jens.schneider.ac@posteo.de" )
                   ( smtpmail-smtp-server  . "posteo.de")
                   ( smtpmail-smtp-service . 587)
		   (mu4e-maildir-shortcuts . ( ("/posteo/Inbox" . ?i)
					       ("/posteo/Sent"  . ?s)
					       ("/posteo/Trash" . ?t)
					       ("/posteo/Dafts" . ?d) ) )
		   ))))
(setq mu4e-change-filenames-when-moving t)

;; Magit Configuration ---------------------------------------------------------

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package evil-magit
  :after magit)

;; work with gitlab forges
(use-package forge
  :config
  (add-to-list 'forge-alist '("git.rwth-aachen.de" "git.rwth-aachen.de/api/v4" "git.rwth-aachen.de" forge-gitlab-repository)))


;; Org Mode Configuration ------------------------------------------------------

(defun acemacs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun acemacs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . acemacs/org-mode-setup)
  :ensure t
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
	'("~/org/"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("note" . ?n)
       ("idea" . ?i)))
  (acemacs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; lsp-mode configuration --------------------------------------

;; lsp-mode 
(defun acemacs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode)
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . acemacs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

;; dap mode for debuggin
(use-package dap-mode
  :config
  (setq dap-ui-controls-mode nil)
  :bind
  ("<f5>" . dap-hydra))

;; company mode for completion
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))


;; snippets and advanced syntax checking
(use-package yasnippet)
(use-package flycheck)

;; python
(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t))

(use-package elpy
  :ensure t
  :hook
  (elpy-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (require 'dap-python)
                          (lsp-deferred)))
  :init
  (elpy-enable))


;; ein for interacting with notebooks
(use-package ein)


;;latex
(use-package lsp-latex)
(use-package tex
  :ensure auctex
  :hook
  (LaTeX-mode . (lambda ()
		  (require 'lsp-latex)
		  (lsp)
		  (yas-minor-mode)))
  :config
  (TeX-source-correlate-mode)
  :custom
  (TeX-source-correlate-start-server t))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(mu4e esup ein flycheck command-log-mode csv-mode dap-python dap-mode which-key use-package smex realgud rainbow-delimiters org-bullets lsp-ui lsp-treemacs lsp-python-ms lsp-latex ivy-rich helpful forge evil-magit evil-collection elpy doom-themes doom-modeline counsel-projectile company-box company-auctex))
 '(safe-local-variable-values
   '((TeX-command-extra-options . "-shell-escape -main-memory=90000000")
     (reftex-default-bibliography "../references.bib")))
 '(smtpmail-smtp-server "posteo.de")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
