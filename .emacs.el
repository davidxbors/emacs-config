; load melpa packagese
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'spacemacs-theme)
  (package-refresh-contents)
  (package-install 'spacemacs-theme))

; load which-key
(use-package which-key
	     :ensure t
	     :init
	     (which-key-mode))

; load company; C&&C++ tab completion
(use-package company
  :ensure t
  :config
  (require 'company)
  (add-to-list 'company-backends 'company-irony))

(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(with-eval-after-load 'company
  (add-hook 'c++-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode))

; remove toolbar and scrollbar
(tool-bar-mode -1)
(scroll-bar-mode -1)

; disable startup screen
(setq inhibit-startup-message t)

; change yes-or-no questions to y-or-n
(defalias 'yes-or-no-p 'y-or-n-p)

; custom dashboard
(use-package dashboard
  :ensure t
  :config
    (dashboard-setup-startup-hook)
    (setq dashboard-startup-banner "~/.emacs.d/img/logo1.png")
    (setq dashboard-items '((recents  . 5)))
    (setq dashboard-banner-logo-title ""))

; relative line number
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

; powerline
; show battery
(display-battery-mode 1)
; show time
(setq display-time-24hr-format t)
(setq display-time-format "%H:%M - %d %B")
(display-time-mode 1)
; show line and col
(setq line-number-mode t)
(setq column-number-mode t)

; erc settings
(setq erc-nick "__zoidberg")
(setq erc-prompt (lambda () (concat "[" (buffer-name) "]")))

(setq erc-server-history-list '("irc.freenode.net"
                                "localhost"))

; set blue mood theme
; set themes directory
(add-to-list 'custom-theme-load-path
             (file-name-as-directory "~/.emacs.d/themes/"))
; require theme
(load-theme 'blue-mood t)
(enable-theme 'blue-mood)

; evil
(require 'evil)
(evil-mode 1)

; .ino syntax
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))

; tramp mode
(setq tramp-default-method "ssh")

; org mode clock persistance
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

; email config
;; load mu4e from the installation path.
;; yours might differ check with the Emacs installation
(use-package mu4e
  :load-path  "/usr/local/share/emacs/site-lisp/mu/mu4e/")

; email
;; we installed this with homebrew
(setq mu4e-mu-binary "/usr/local/Cellar/mu/1.6.8/bin/mu")

;; for sending mails
(require 'smtpmail)

;; this is the directory we created before:
(setq mu4e-maildir "~/.maildir")

;; this command is called to sync imap servers:
(setq mu4e-get-mail-command (concat (executable-find "mbsync") " -a"))
;; how often to call it in seconds:
(setq mu4e-update-interval 300)

;; save attachment to desktop by default
;; or another choice of yours:
(setq mu4e-attachment-dir "~/Desktop")

;; rename files when moving - needed for mbsync:
(setq mu4e-change-filenames-when-moving t)

;; list of your email adresses:
(setq mu4e-user-mail-address-list '("daviddvd267@gmail.com"
                                    "david_stefan.bors@curs.acs.upb.ro"))

;; check your ~/.maildir to see how the subdirectories are called
;; for the generic imap account:
;; e.g `ls ~/.maildir/example'
(setq   mu4e-maildir-shortcuts
        '(("/gmail/INBOX" . ?g)
          ("/gmail/[Gmail]/Sent Mail" . ?G)
          ("/UPB/Inbox" . ?e)
          ("/UPB/Sent Items" . ?E)))

;; the following is to show shortcuts in the main view.
(add-to-list 'mu4e-bookmarks
             (make-mu4e-bookmark
              :name "Inbox - Gmail"
              :query "maildir:/gmail/INBOX"
              :key ?g))
(add-to-list 'mu4e-bookmarks
             (make-mu4e-bookmark
              :name "Inbox - UPB"
              :query "maildir:/UPB/Inbox"
              :key ?e))

(setq mu4e-contexts
      `(,(make-mu4e-context
          :name "gmail"
          :enter-func
          (lambda () (mu4e-message "Enter daviddvd267@gmail.com context"))
          :leave-func
          (lambda () (mu4e-message "Leave daviddvd267@gmail.com context"))
          :match-func
          (lambda (msg)
            (when msg
              (mu4e-message-contact-field-matches msg
                                                  :to "daviddvd267@gmail.com")))
          :vars '((user-mail-address . "daviddvd267@gmail.com")
                  (user-full-name . "David Borș")
                  (mu4e-drafts-folder . "/GMAIL/Drafts")
                  (mu4e-refile-folder . "/GMAIL/Archive")
                  (mu4e-sent-folder . "/GMAIL/Sent")
                  (mu4e-trash-folder . "/GMAIL/Trash")))

        ,(make-mu4e-context
          :name "upb"
          :enter-func
          (lambda () (mu4e-message "Enter david_stefan.bors@stud.acs.upb.ro context"))
          :leave-func
          (lambda () (mu4e-message "Leave david_stefan.bors@stud.acs.upb.ro context"))
          :match-func
          (lambda (msg)
            (when msg
              (mu4e-message-contact-field-matches msg
                                                  :to "david_stefan.bors@stud.acs.upb.ro")))
          :vars '((user-mail-address . "david_stefan.bors@stud.acs.upb.ro")
                  (user-full-name . "David Borș")
                  ;; check your ~/.maildir to see how the subdirectories are called
                  ;; e.g `ls ~/.maildir/example'
                  (mu4e-drafts-folder . "/UPB/Drafts")
                  (mu4e-refile-folder . "/UPB/Archive")
                  (mu4e-sent-folder . "/UPB/Sent Items")
                  (mu4e-trash-folder . "/UPB/Trash")))))

(setq mu4e-context-policy 'pick-first) ;; start with the first (default) context;
(setq mu4e-compose-context-policy 'ask) ;; ask for context if no context matches;

;; show images
(setq mu4e-show-images t)

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; don't have to confirm when quitting:
(setq mu4e-confirm-quit nil)

;; gpg encryptiom & decryption:
;; this can be left alone
(require 'epa-file)
(epa-file-enable)
(setq epa-pinentry-mode 'loopback)
(auth-source-forget-all-cached)

;; don't keep message compose buffers around after sending:
(setq message-kill-buffer-on-exit t)

;; send function:
(setq send-mail-function 'sendmail-send-it
      message-send-mail-function 'sendmail-send-it)

;; send program:
;; this is exeranal. remember we installed it before.
(setq sendmail-program (executable-find "msmtp"))

;; select the right sender email from the context.
(setq message-sendmail-envelope-from 'header)

;; chose from account before sending
;; this is a custom function that works for me.
;; well I stole it somewhere long ago.
;; I suggest using it to make matters easy
;; of course adjust the email adresses and account descriptions
;(defun timu/set-msmtp-account ()
  ;(if (message-mail-p)
      ;(save-excursion
        ;(let*
            ;((from (save-restriction
                     ;(message-narrow-to-headers)
                     ;(message-fetch-field "from")))
             ;(account
              ;(cond
               ;((string-match "daviddvd267@gmail.com" from) "gmail")
               ;((string-match "david_stefan.bors@stud.acs.upb.ro" from) "upb"))))
          ;(setq message-sendmail-extra-arguments (list '"-a" account))))))
;
;(add-hook 'message-send-mail-hook 'timu/set-msmtp-account)

;; mu4e cc & bcc
;; this is custom as well
;(add-hook 'mu4e-compose-mode-hook
          ;(defun timu/add-cc-and-bcc ()
            ;"My Function to automatically add Cc & Bcc: headers.
    ;This is in the mu4e compose mode."
            ;(save-excursion (message-add-header "Cc:\n"))
            ;(save-excursion (message-add-header "Bcc:\n"))))

;; mu4e address completion
(add-hook 'mu4e-compose-mode-hook 'company-mode)
;; gpg encryptiom & decryption:
;; this can be left alone
(require 'epa-file)
(epa-file-enable)
(setq epa-pinentry-mode 'loopback)
(auth-source-forget-all-cached)

;; don't keep message compose buffers around after sending:
(setq message-kill-buffer-on-exit t)

;; send function:
(setq send-mail-function 'sendmail-send-it
      message-send-mail-function 'sendmail-send-it)

; auto-written
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(package-selected-packages
   '(dashboard rainbow-delimiters evil spacemacs-theme use-package which-key)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
