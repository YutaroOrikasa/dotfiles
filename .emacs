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
 '(custom-enabled-themes (quote (myadwi)))
 '(custom-safe-themes
   (quote
    ("865d548bf2b64f985348d3cdcba8e8fd3eba24abd21b095c2285914803e30bcb" "fe03ab76286b5a496bccee645b27543b724a6149bbd6e009662ab8b09ea66ca2" "fba7eb9099b49afe266682bb5ae1bb1c4bea94f592111a28f524ca64e633268f" "0598b8fe7d82edf48d54ab916306f4afa10d2b64ea4650deb61806e120d55e74" "c6041e4effd30c6013c9f43d986de0236062d1d811495ebff33bf39afa8ff583" default)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
