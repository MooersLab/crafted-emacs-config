;;; example-config.el -- Example Crafted Emacs user customization file -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Crafted Emacs supports user customization through a `config.el' file
;; similar to this one.  You can copy this file as `config.el' to your
;; Crafted Emacs configuration directory as an example.
;;
;; In your configuration you can set any Emacs configuration variable, face
;; attributes, themes, etc as you normally would.
;;
;; See the README.org file in this repository for additional information.

;;; Code:
;; At the moment, Crafted Emacs offers the following modules.
;; Comment out everything you don't want to use.
;; At the very least, you should decide whether or not you want to use
;; evil-mode, as it will greatly change how you interact with Emacs.
;; So, if you prefer Vim-style keybindings over vanilla Emacs keybindings
;; remove the comment in the line about `crafted-evil' below.
(require 'crafted-defaults)    ; Sensible default settings for Emacs
(require 'crafted-updates)     ; Tools to upgrade Crafted Emacs
(require 'crafted-ide)         ; A general configuration to make Emacs more like an IDE, uses eglot.
(require 'crafted-completion)  ; selection framework based on `vertico`
(require 'crafted-ui)          ; Better UI experience (modeline etc.)
(require 'crafted-windows)     ; Window management configuration
(require 'crafted-editing)     ; Whitspace trimming, auto parens etc.
;;(require 'crafted-evil)        ; An `evil-mode` configuration
(require 'crafted-org)         ; org-appear, clickable hyperlinks etc.
(require 'crafted-ide)         ; A general configuration to make Emacs more like an IDE, uses eglot.
(require 'crafted-latex)       ; A configuration for creating documents using the LaTeX typesetting language
(require 'crafted-python)       ; A configuration for
(require 'crafted-lisp)        ; A configuration for creating documents using the LaTeX typesetting language
(require 'crafted-pdf-reader)        ; A configuration for creating documents using the LaTeX typesetting language
(require 'crafted-mastering-emacs)        ; A configuration for creating documents using the LaTeX typesetting language
(require 'crafted-osx)        ; A configuration for creating documents using the LaTeX typesetting language
;;(require 'crafted-project)     ; built-in alternative to projectile
(require 'crafted-speedbar)    ; built-in file-tree
;(require 'crafted-screencast)  ; show current command and binding in modeline
(require 'crafted-compile)     ; automatically compile some emacs lisp files

;; Set the default face. The default face is the basis for most other
;; faces used in Emacs. A "face" is a configuration including font,
;; font size, foreground and background colors and other attributes.
;; The fixed-pitch and fixed-pitch-serif faces are monospace faces
;; generally used as the default face for code. The variable-pitch
;; face is used when `variable-pitch-mode' is turned on, generally
;; whenever a non-monospace face is preferred.
;;
;; I downloaded and install the fonts below from https://www.jetbrains.com/lp/mono/
(add-hook 'emacs-startup-hook
          (lambda ()
            (custom-set-faces
             `(default ((t (:font "JetBrains Mono Light 18"))))
             `(fixed-pitch ((t (:inherit (default)))))
             `(fixed-pitch-serif ((t (:inherit (default)))))
             `(variable-pitch ((t (:font "Arial 18")))))))

;; Themes are color customization packages which coordinate the
;; various colors, and in some cases, font-sizes for various aspects
;; of text editing within Emacs, toolbars, tabbars and
;; modeline. Several themes are built-in to Emacs, by default,
;; Crafted Emacs uses the `deeper-blue' theme. Here is an example of
;; loading a different theme from the venerable Doom Emacs project.
(crafted-package-install-package 'doom-themes)
(progn
  (disable-theme 'deeper-blue)          ; first turn off the deeper-blue theme
  (load-theme 'doom-palenight t))       ; load the doom-palenight theme

;; To not load `custom.el' after `config.el', uncomment this line.
;; (setq crafted-load-custom-file nil)

;;; example-config.el ends here

;;; Below is Blaine's configuration

;; Mac key bindings
(setq mac-command-modifier 'meta) ; make cmd key do Meta
(setq mac-option-modifier 'super) ; make option key do Super.
(setq mac-control-modifier 'control) ; make Control key do Control
(setq mac-function-modifier 'hyper)  ; make Fn key do Hyper. Only works on Apple produced keyboards.
(setq mac-right-command-modifier 'hyper)


;;; Buffer switching
;; Switch to previous buffer
(define-key global-map (kbd "s-<left>") 'previous-buffer)
;; Switch to next buffer
(define-key global-map (kbd "s-<right>") 'next-buffer)


;; Minibuffer history keybindings
;; The calling up of a previously issued command in the minibuffer with ~M-p~ saves times.
(autoload 'edit-server-maybe-dehtmlize-buffer "edit-server-htmlize" "edit-server-htmlize" t)
(autoload 'edit-server-maybe-htmlize-buffer "edit-server-htmlize" "edit-server-htmlize" t)
(add-hook 'edit-server-start-hook 'edit-server-maybe-dehtmlize-buffer)
(add-hook 'edit-server-done-hook  'edit-server-maybe-htmlize-buffer)
(define-key minibuffer-local-map (kbd "M-p") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "M-n") 'next-complete-history-element)
(define-key minibuffer-local-map (kbd "<up>") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "<down>") 'next-complete-history-element)


;; Highlight current line (Needs more tweaking with current dark theme.)
(global-hl-line-mode +1)
(add-to-list 'default-frame-alist '(background-color . "lightmagenta"))
(set-face-background 'hl-line "gray")
(set-face-attribute 'mode-line nil :height 260)


;;### Move selected regions up or down
;; It is commands like these one that enable rapid reorganization of your prose when writing one sentence per row.
;; Thank you to DivineDomain for the suggested upgrade.
;; Source: https://www.emacswiki.org/emacs/MoveText
(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (let ((column (current-column)))
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
        (forward-line)
        (when (or (< arg 0) (not (eobp)))
          (transpose-lines arg))
        (forward-line -1))
      (move-to-column column t)))))

(defun move-line-region-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-line-region-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

(global-set-key (kbd "M-<down>") 'move-line-region-down)
(global-set-key (kbd "M-<up>") 'move-line-region-up)




;;;### Package configuration;;;;;;;;;;;;;;;;;;;;;

;; A
;; atomic-chrome, used to interact with GhostText extension for Google Chrome.
(use-package atomic-chrome)
(atomic-chrome-start-server)
(setq atomic-chrome-default-major-mode 'python-mode)
(setq atomic-chrome-extension-type-list '(ghost-text))
;;(atomic-chrome-start-httpd)
(setq atomic-chrome-server-ghost-text-port 4001)
(setq atomic-chrome-url-major-mode-alist
      '(("github\\.com" . gfm-mode)
        ("overleaf.com" . latex-mode)
        ("750words.com" . latex-mode)))
                                        ; Select the style of opening the editing buffer by atomic-chrome-buffer-open-style.
                                        ; full: Open in the selected window.
                                        ; split: Open in the new window by splitting the selected window (default).
                                        ; frame: Create a new frame and window in it. Must be using some windowing pacakge.
(setq atomic-chrome-buffer-open-style 'split)


;;; B
;;### bibtex-mode related
;; Fetch bibtex for the given DOI. Insert at point, which should be in your global.bib file.
;; Needs code to reformat the bibtex key.
;;
;; https://www.anghyflawn.net/blog/2014/emacs-give-a-doi-get-a-bibtex-entry/
(defun get-bibtex-from-doi (doi)
  "Get a BibTeX entry from the DOI"
  (interactive "MDOI: ")
  (let ((url-mime-accept-string "text/bibliography;style=bibtex"))
    (with-current-buffer
        (url-retrieve-synchronously
         (format "http://dx.doi.org/%s"
                         (replace-regexp-in-string "http://dx.doi.org/" "" doi)))
      (switch-to-buffer (current-buffer))
      (goto-char (point-max))
      (setq bibtex-entry
            (buffer-substring
             (string-match "@" (buffer-string))
             (point)))
      (kill-buffer (current-buffer))))
  (insert (decode-coding-string bibtex-entry 'utf-8))
  (define-key bibtex-mode-map (kbd "C-c b") 'get-bibtex-from-doi)
  (bibtex-fill-entry))
;; I want run the above function to define it upon entry into a Bibtex file.
(add-hook
 'bibtex-mode-hook
 (lambda ()
   (get-bibtex-from-doi nil)))

;;; C

;; Configuration for citar, a BibTeX manager compatible with the vertico stack.
;; Source: https://github.com/emacs-citar/citar
(use-package citar
  :bind (("C-c b" . citar-insert-citation)
         :map minibuffer-local-map
         ("M-b" . citar-insert-preset))
  :custom
  (citar-bibliography '("/Users/blaine/Documents/global.bib")))

(use-package citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))

;;; D
;;; E
;;; F
;;; G
;;; H
;;; I
;;; J
;;; K
;;; L
;;## L

;;### LanguageTool

(use-package languagetool
  :ensure t
  :defer t
  :commands (languagetool-check
             languagetool-clear-suggestions
             languagetool-correct-at-point
             languagetool-correct-buffer
             languagetool-set-language
             languagetool-server-mode
             languagetool-server-start
             languagetool-server-stop)
  :config
  (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8")
        languagetool-console-command "~/.languagetool/languagetool-commandline.jar"
        languagetool-server-command "~/.languagetool/languagetool-server.jar"))

        (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8"))

        (setq languagetool-console-command "~/.languagetool/languagetool-commandline.jar"
              languagetool-server-command "~/.languagetool/languagetool-server.jar")

;;### LaTeX helpher functions
;;#### M-x description
;; Converts a selected list into a description list.
;; The elements of the list must begin with a dash.
;; The terms to be inserted into the square brackets
;; have to be added after running the function.
(defun description (beg end)
  "wrap the active region in an 'itemize' environment,
  converting hyphens at the beginning of a line to \item"
  (interactive "r")
  (save-restriction
    (narrow-to-region beg end)
    (beginning-of-buffer)
    (insert "\\begin{description}\n")
    (while (re-search-forward "^- " nil t)
      (replace-match "\\\\item[ ]"))
    (end-of-buffer)
    (insert "\\end{description}\n")))


;;#### M-x enumerate
;; Converts a selected list into an enumerated list.
;; The elements of the list must begin with a dash.
(defun enumerate (beg end)
  "wrap the active region in an 'itemize' environment,
  converting hyphens at the beginning of a line to \item"
  (interactive "r")
  (save-restriction
    (narrow-to-region beg end)
    (beginning-of-buffer)
    (insert "\\begin{enumerate}\n")
    (while (re-search-forward "^- " nil t)
      (replace-match "\\\\item "))
    (end-of-buffer)
    (insert "\\end{enumerate}\n")))


;;#### M-x itemize
;; Converts a selected list into an itemized list.
;; The elements of the list must begin with a dash.
;; A similar function could be made to make an enumerated list
;; and a description list.
;; Source: \url{https://tex.stackexchange.com/questions/118958/emacsauctex-prevent-region-filling-when-inserting-itemize}
(defun itemize (beg end)
  "wrap the active region in an 'itemize' environment,
  converting hyphens at the beginning of a line to \item"
  (interactive "r")
  (save-restriction
    (narrow-to-region beg end)
    (beginning-of-buffer)
    (insert "\\begin{itemize}\n")
    (while (re-search-forward "^- " nil t)
      (replace-match "\\\\item "))
    (end-of-buffer)
    (insert "\\end{itemize}\n")))

;;; M
;;; N
;;; O

(define-key global-map (kbd "C-c a") 'org-agenda)
(setq org-log-done t)
;; org-capture
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cl" 'org-store-link)

(setq org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA")

(setq org-agenda-files '("/Users/blaine/gtd/tasks/JournalArticles.org"
                         "/Users/blaine/gtd/tasks/Proposals.org"
                         "/Users/blaine/gtd/tasks/Books.org"
                         "/Users/blaine/gtd/tasks/Talks.org"
                         "/Users/blaine/gtd/tasks/Posters.org"
                         "/Users/blaine/gtd/tasks/ManuscriptReviews.org"
                         "/Users/blaine/gtd/tasks/Private.org"
                         "/Users/blaine/gtd/tasks/Service.org"
                         "/Users/blaine/gtd/tasks/Teaching.org"
                         "/Users/blaine/gtd/tasks/Workshops.org"))

;; Cycle through these keywords with shift right or left arrows.
(setq org-todo-keywords
      '((sequence "TODO(t)" "INITIATED(i!)" "WAITING(w!)" "CAL(a)" "SOMEDAY(s!)" "PROJ(j)" "|" "DONE(d!)" "CANCELLED(c!)")))

(setq org-refile-targets '(("/Users/blaine/gtd/tasks/JournalArticles.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/Proposals.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/Books.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/Talks.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/Posters.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/ManuscriptReviews.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/Private.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/Service.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/Teaching.org" :maxlevel . 2)
                           ("/Users/blaine/gtd/tasks/Workshops.org" :maxlevel . 2)))
(setq org-refile-use-outline-path 'file)

(setq org-agenda-custom-commands
      '(
        ("b"
         "List of all active 402 tasks."
         tags-todo
         "402\"/TODO|INITIATED|WAITING")
        ("c"
         "List of all active 523 RNA-drug crystallization review paper tasks."
         tags-todo
         "CATEGORY=\"523\"/TODO|INITIATED|WAITING")
        ("d"
         "List of all active 485PyMOLscGUI tasks."
         tags-todo
         "CATEGORY=\"485\"/TODO|INITIATED|WAITING")
        ("e"
         "List of all active 2104 Emacs tasks"
         tags-todo
         "2104+CATEGORY=\"2104\"/NEXT|TODO|INITIATED|WAITING")
        ("n"
         "List of all active 651 ENAX2 tasks"
         tags-todo
         "651+CATEGORY=\"651\"/NEXT|TODO|INITIATED|WAITING")
        ("q"
         "List of all active 561 charge density review"
         tags
         "561+CATEGORY=\"211\"/NEXT|TODO|INITIATED|WAITING")
        ("r"
         "List of all active 211 rcl/dnph tasks"
         tags-todo
         "211+CATEGORY=\"211\"/NEXT|TODO|INITIATED|WAITING")
        ("P"
         "List of all projects"
         tags
         "LEVEL=2/PROJ")))



(defun org-ask-location ()
  (let* ((org-refile-targets '((nil :maxlevel . 9)))
         (hd (condition-case nil
                 (car (org-refile-get-location "Tag" nil t))
               (error (car org-refile-history)))))
    (goto-char (point-min))
    (outline-next-heading)
    (if (re-search-forward
         (format org-complex-heading-regexp-format (regexp-quote hd))
         nil t)
        (goto-char (point-at-bol))
      (goto-char (point-max))
      (or (bolp) (insert "\n"))
      (insert "* " hd "\n")))
  (end-of-line))

(setq org-capture-templates
      '(
        ("j" "JournalArticles" entry
         (file+function "/Users/blaine/gtd/tasks/JournalArticles.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("g" "GrantProposals" entry
         (file+function "/Users/blaine/gtd/tasks/Proposals.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("b" "Books" entry
         (file+function "/Users/blaine/gtd/tasks/Books.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("t" "Talks" entry
         (file+function "/Users/blaine/gtd/tasks/Talks.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("p" "Posters" entry
         (file+function "/Users/blaine/gtd/tasks/Posters.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("r" "ManuscriptReviews" entry
         (file+function "/Users/blaine/gtd/tasks/ManuscriptReviews.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("v" "Private" entry
         (file+function "/Users/blaine/gtd/tasks/Private.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("S" "Service" entry
         (file+function "/Users/blaine/gtd/tasks/Service.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("T" "Teaching" entry
         (file+function "/Users/blaine/gtd/tasks/Teaching.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("w" "Workshop" entry
         (file+function "/Users/blaine/gtd/tasks/Workshops.org" org-ask-location)
         "\n\n*** TODO %?\n<%<%Y-%m-%d %a %T>>"
         :empty-lines 1)
        ("s" "Slipbox" entry  (file "/User/org-roam/inbox.org")
         "* %?\n")
        ))

;;; org-drill
(use-package org-drill
  :ensure t
  :config (progn
            (add-to-list 'org-modules 'org-drill)
            (setq org-drill-add-random-noise-to-intervals-p t)
            (setq org-drill-hint-separator "||")
            (setq org-drill-left-cloze-delimiter "<[")
            (setq org-drill-right-cloze-delimiter "]>")
            (setq org-drill-learn-fraction 0.25)
            )
  )


;; org-noter and org-noter-pdftools

(use-package org-noter
  :config
  ;; Your org-noter config ........
  (require 'org-noter-pdftools))

(use-package org-pdftools
  :hook (org-mode . org-pdftools-setup-link))

(use-package org-noter-pdftools
  :after org-noter
  :config
  ;; Add a function to ensure precise note is inserted
  (defun org-noter-pdftools-insert-precise-note (&optional toggle-no-questions)
    (interactive "P")
    (org-noter--with-valid-session
     (let ((org-noter-insert-note-no-questions (if toggle-no-questions
                                                   (not org-noter-insert-note-no-questions)
                                                 org-noter-insert-note-no-questions))
           (org-pdftools-use-isearch-link t)
           (org-pdftools-use-freepointer-annot t))
       (org-noter-insert-note (org-noter--get-precise-info)))))

  ;; fix https://github.com/weirdNox/org-noter/pull/93/commits/f8349ae7575e599f375de1be6be2d0d5de4e6cbf
  (defun org-noter-set-start-location (&optional arg)
    "When opening a session with this document, go to the current location.
With a prefix ARG, remove start location."
    (interactive "P")
    (org-noter--with-valid-session
     (let ((inhibit-read-only t)
           (ast (org-noter--parse-root))
           (location (org-noter--doc-approx-location (when (called-interactively-p 'any) 'interactive))))
       (with-current-buffer (org-noter--session-notes-buffer session)
         (org-with-wide-buffer
          (goto-char (org-element-property :begin ast))
          (if arg
              (org-entry-delete nil org-noter-property-note-location)
            (org-entry-put nil org-noter-property-note-location
                           (org-noter--pretty-print-location location))))))))
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))





;; org-pomodoro
(use-package org-pomodoro
  :ensure t
  :commands (org-pomodoro)
  :config
  (setq alert-user-configuration (quote ((((:category . "org-pomodoro")) libnotify nil)))))
(global-set-key (kbd "C-c o") 'org-pomodoro)


;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "/Users/blaine/org-roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))



;;## Basic org-roam config
;; Following https://jethrokuan.github.io/org-roam-guide/

(setq org-roam-capture-templates
      '(("m" "main" plain
         "%?"
         :if-new (file+head "main/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("r" "reference" plain "%?"
         :if-new
         (file+head "reference/${title}.org" "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("a" "article" plain "%?"
         :if-new
         (file+head "articles/${title}.org" "#+title: ${title}\n#+filetags: :article:\n")
         :immediate-finish t
         :unnarrowed t)))


(setq org-roam-node-display-template
      (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))


(defun jethro/org-roam-node-from-cite (keys-entries)
  (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
  (let ((title (citar--format-entry-no-widths (cdr keys-entries)
                                              "${author editor} :: ${title}")))
    (org-roam-capture- :templates
                       '(("r" "reference" plain "%?" :if-new
                          (file+head "reference/${citekey}.org"
                                     ":PROPERTIES:
:ROAM_REFS: [cite:@${citekey}]
:END:
#+title: ${title}\n")
                          :immediate-finish t
                          :unnarrowed t))
                       :info (list :citekey (car keys-entries))
                       :node (org-roam-node-create :title title)
                       :props '(:finalize find-file))))


(defun jethro/tag-new-node-as-draft ()
  (org-roam-tag-add '("draft")))
(add-hook 'org-roam-capture-new-node-hook #'jethro/tag-new-node-as-draft)

;;; org-roam-bibtex
(use-package org-roam-bibtex
  :hook (org-roam-mode . org-roam-bibtex-mode))

(setq orb-preformat-keywords
      '("citekey" "title" "url" "author-or-editor" "keywords" "file")
      orb-process-file-keyword t
      orb-file-field-extensions '("pdf"))

(setq orb-templates
      '(("r" "ref" plain(function org-roam-capture--get-point)
         ""
         :file-name "${citekey}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}
  - tags ::
  - keywords :: ${keywords}

  *Notes
  :PROPERTIES:
  :Custom_ID: ${citekey}
  :URL: ${url}
  :AUTHOR: ${author-or-editor}
  :NOTER_DOCUMENT: ${file}
  :NOTER_PAGE:
  :END:")))



;; *** org-tree-to-indirect-buffer
;;
;; This function address the shortcoming of org-tree-to-indirect-buffer which is that there can only be one such indirect buffer per Org mode file.
;; [[https://www.reddit.com/r/orgmode/comments/dbsngi/comment/f26qpzr/][Source]].
;; Its purpose is to provide more than one indirect buffer when using org-tree-to-indirect-buffer() (via C-c C-x b).
;; This latter function is built-in.
;; Repeating C-c C-x b will drill down to the lowest headline level.

(defun my-org-tree-to-indirect-buffer (&optional arg)
  "Create indirect buffer and narrow it to current subtree.
The buffer is named after the subtree heading, with the filename
appended.  If a buffer by that name already exists, it is
selected instead of creating a new buffer."
  (interactive "P")
  (let* ((new-buffer-p)
         (pos (point))
         (buffer-name (let* ((heading (org-get-heading t t))
                             (level (org-outline-level))
                             (face (intern (concat "outline-" (number-to-string level))))
                             (heading-string (propertize (org-link-display-format heading)
                                                         'face face)))
                        (concat heading-string "::" (buffer-name))))
         (new-buffer (or (get-buffer buffer-name)
                         (prog1 (condition-case nil
                                    (make-indirect-buffer (current-buffer) buffer-name 'clone)
                                  (error (make-indirect-buffer (current-buffer) buffer-name)))
                           (setq new-buffer-p t)))))
    (switch-to-buffer new-buffer)
    (when new-buffer-p
      ;; I don't understand why setting the point again is necessary, but it is.
      (goto-char pos)
      (rename-buffer buffer-name)
      (org-narrow-to-subtree))))

(advice-add 'org-tree-to-indirect-buffer :override 'my-org-tree-to-indirect-buffer)
(global-set-key (kbd "C-c i b") 'my-org-tree-to-indirect-buffer)

;; Note: a similar effect is had using a tag via (e.g., C-c \ m and enter tag at the prompt in the minibuffer).

;;; P
;;; Q
;;; R
;;; S
;;; T
;;### TeXcount setup for TeXcount version 2.3 and later
;; See https://app.uio.no/ifi/texcount/howto.html to use from the command line.
(defun texcount ()
  (interactive)
  (let*
      ( (this-file (buffer-file-name))
        (enc-str (symbol-name buffer-file-coding-system))
        (enc-opt
         (cond
          ((string-match "utf-8" enc-str) "-utf8")
          ((string-match "latin" enc-str) "-latin1")
          ("-encoding=guess")
          ) )
        (word-count
         (with-output-to-string
           (with-current-buffer standard-output
             (call-process "/opt/local/bin/texcount" nil t nil "-0" enc-opt this-file)
             ) ) ) )
    (message word-count)
    ) )
(add-hook 'LaTeX-mode-hook (lambda () (define-key LaTeX-mode-map (kdb "C-c w") 'texcount)))


;;; U
;;; V


;;; W
;;### activate word count mode
;; This mode will count the LaTeX markup, but it does give the count of incrementally added words.
(use-package wc-mode)
(add-hook 'text-mode-hook 'wc-mode)
;; Suggested setting
(global-set-key "\C-cw" 'wc-mode)

;;; X
;;; Y
(global-set-key "\C-o" 'yas-expand)
;;; Z
