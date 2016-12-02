(defun mine--try-require-fun (module &optional  body)
  "implementation for try-require"
  (if (require module nil t)
      (eval body)
    (message "Require error: %s" module)))

(defmacro try-require (module &optional body)
  "If module load successed, body will be evaluated."
  (mine--try-require-fun (eval module) body))

(defun mine--try-load-fun (filename &optional  body)
  "implementation for try-load"
  (if (load filename t)
      (eval body)
    (message "Load error: %s" filename)))

(defmacro try-load (filename &optional body)
  "If elisp file load successed, body will be evaluated."
  (mine--try-load-fun filename body))

(setq load-path
      (append '("~/.emacs.d/mylisp") load-path))
              
(try-load "my")

(setq dired-listing-switches "-laGh1v")

(global-hl-line-mode t)                 ;; 現在行をハイライト

;; (custom-set-faces
;;  '(hl-line ((t (:background "#00bf00"))))
;;  )

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)  
(global-set-key (kbd "M-j") 'jedi:complete)

;; ;; python-mode (launchpad)
;; (autoload 'python-mode "python-mode" nil t)
;; (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
;; rope
(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(eval-after-load 'python (lambda()
                           (autoload 'pymacs-apply "pymacs")
                           (autoload 'pymacs-call "pymacs")
                           (autoload 'pymacs-eval "pymacs" nil t)
                           (autoload 'pymacs-exec "pymacs" nil t)
                           (autoload 'pymacs-load "pymacs" nil t)
                           (pymacs-load "ropemacs" "rope-")
                           (define-key ropemacs-local-keymap "\M-/" 'dabbrev-expand)
                           ))
(add-hook 'python-mode-hook (lambda()
			      (message "py hook!")))

;; (ac-ropemacs-initialize)
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;                     (add-to-list 'ac-sources 'ac-source-ropemacs)))

;; remove suck python default dict
(add-hook 'python-mode-hook (lambda ()
                              (setq ac-sources '(ac-source-abbrev
                                                 ac-source-words-in-same-mode-buffers))))
                                 

;; ;;; *.~ とかのバックアップファイルを作らない
;; (setq make-backup-files nil)
;; ;;; .#* とかのバックアップファイルを作らない
;; (setq auto-save-default nil)

(setq-default truncate-lines t)

;; reverse yank-pop
;; http://www.emacswiki.org/emacs/KillingAndYanking
(defun yank-pop-forwards (arg)
  (interactive "p")
  (yank-pop (- arg)))

(global-set-key "\M-Y" 'yank-pop-forwards) ; M-Y (Meta-Shift-Y)


;; オートインデントでスペースを使う
(setq-default indent-tabs-mode nil)

;; ansi-term のキーバインド
(add-hook 'term-mode-hook
          (lambda()
                (define-key term-raw-map (kbd "M-y") 'term-paste)))

(add-hook 'term-mode-hook
          (lambda()
                (define-key term-raw-map (kbd "M-n") 'scroll-up)))
(add-hook 'term-mode-hook
          (lambda()
                (define-key term-raw-map (kbd "M-p") 'scroll-down)))

;; tramp sudo
;;(require 'tramp)
(eval-after-load 'tramp '(add-to-list 'tramp-default-proxies-alist
                                      '(nil "\\`root\\'" "/ssh:%h:")))
(eval-after-load 'tramp '(add-to-list 'tramp-default-proxies-alist
                                      '("localhost" nil nil)))
(eval-after-load 'tramp '(add-to-list 'tramp-default-proxies-alist
                                      '((regexp-quote (system-name)) nil nil)))

;; (add-to-list 'load-path "/emacs")

(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])

(define-key global-map (kbd "C-h") 'backward-delete-char-untabify)
;; not work
;; (global-set-key "C-h" 'backward-delete-char-untabify)


;; to mouse wheel scroll in gnu screen (ti@:te@ mode)
(xterm-mouse-mode t)
(global-set-key   [mouse-5] 'next-line)
(global-set-key   [mouse-4] 'previous-line)



(try-require 'zlc
             (
              (zlc-mode t)

              (let
                  ((map minibuffer-local-map))
                ;; like menu select
                (define-key map (kbd "C-<down>")  'zlc-select-next-vertical)
                (define-key map (kbd "C-<up>")    'zlc-select-previous-vertical)
                (define-key map (kbd "C-<right>") 'zlc-select-next)
                (define-key map (kbd "C-<left>")  'zlc-select-previous)

                ;; reset selection
                (define-key map (kbd "C-c") 'zlc-reset))))


(require 'package)
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; MELPA-stableを追加
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; Orgを追加
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;; 初期化
(package-initialize)


(ac-config-default)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (myadwi)))
 '(custom-safe-themes
   (quote
    ("0b6b364c37c1bfe2781e5447377a80cc0f2422ee3ed39f7c3afd72903f7c09cd" "7009f201dfa0c9a73fe2d0446307c9e29443da8b547d519548ab8c8ad4ceb597" "e1e116712f8e41cc0fc22a46ee7752e1b600c3e3500adb8313341acb2378d752" "899c1c7e5aef9643a1651efcab75cfc1be35b2d9f40969fb4bcfa369fd7e6a2a" "cc9d1ef81d06bf7694f845da93e6d7000339cc963510f6ba92cbb3241cad63c7" "681f3f7effbb8fb0540bd8363a1e1f2ded27fe12c7349ddeda2cef4ad1821698" "d4f0d4ac30b5c1ce0f9a246a168551279fe4a198db8d943043ad4aa7ee7e42a9" "163493e8fe3f991366074f374963e90b4b05471431d84864267c6520c77acd27" "3ea3c3da3d7db2c68d40b339c6ebd5cb65ba40497ce854f1fdbd41282063c5d6" "a0a5339b063dbc17de7a94b006332a74db227be3deb19d0d9ee1a56af1f4fb02" "18048772dabe0c3d8099fd06f40ae68375ed8a297c6fa48a97a9216d04f98514" "0fe8921a5130435eefb4aba382d186f16f5121afffac43b06a52f6940695492d" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
