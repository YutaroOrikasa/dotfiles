;; set default theme
(load-theme 'myadwi t)


;; save customized variables to "custom.el"
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

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

;; install el-get automatically on launch
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

;; this make error
;; (el-get 'sync)

(el-get-bundle auto-complete
  (progn (ac-config-default)))



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

(setq dired-listing-switches "-lahv")

(global-hl-line-mode t)                 ;; 現在行をハイライト

;; (custom-set-faces
;;  '(hl-line ((t (:background "#00bf00"))))
;;  )

;; jedi
 (el-get-bundle jedi
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t)
  (global-set-key (kbd "M-j") 'jedi:complete))

;; ;; python-mode (launchpad)
;; (autoload 'python-mode "python-mode" nil t)
;; (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))

 ;; rope
(el-get-bundle ropemacs
  (eval-after-load 'python (lambda()
                             (autoload 'pymacs-apply "pymacs")
                             (autoload 'pymacs-call "pymacs")
                             (autoload 'pymacs-eval "pymacs" nil t)
                             (autoload 'pymacs-exec "pymacs" nil t)
                             (autoload 'pymacs-load "pymacs" nil t)
                             (pymacs-load "ropemacs" "rope-")
                             (define-key ropemacs-local-keymap "\M-/" 'dabbrev-expand)
                             )))

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


;; wrap lines
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)


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
             (lambda()
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



(defun my-delete-other-frames (&optional frame)
  (interactive)
  (if (yes-or-no-p "Really delete all other frames?")
      (delete-other-frames frame)))
(define-key global-map (kbd "C-x 5 1") 'my-delete-other-frames)


;; key bindings for window moving
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

(global-set-key (kbd "C-c C-<left>")  'windmove-left)
(global-set-key (kbd "C-c C-<right>") 'windmove-right)
(global-set-key (kbd "C-c C-<up>")    'windmove-up)
(global-set-key (kbd "C-c C-<down>")  'windmove-down)

(global-set-key (kbd "C-x S-<left>")  'windmove-left)
(global-set-key (kbd "C-x S-<right>") 'windmove-right)
(global-set-key (kbd "C-x S-<up>")    'windmove-up)
(global-set-key (kbd "C-x S-<down>")  'windmove-down)

(global-set-key (kbd "S-<left>")  'windmove-left)
(global-set-key (kbd "S-<right>") 'windmove-right)
(global-set-key (kbd "S-<up>")    'windmove-up)
(global-set-key (kbd "S-<down>")  'windmove-down)

;; key bindings for change window size
(global-set-key (kbd "S-M-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-M-<down>") 'shrink-window)
(global-set-key (kbd "S-M-<up>") 'enlarge-window)

(set-face-attribute 'default nil :height 200)

(electric-pair-mode 1)

(savehist-mode 1)

(setq bookmark-save-flag 1) 

(el-get-bundle zoom-window
  (global-set-key (kbd "C-x z") 'zoom-window-zoom)
  (setq zoom-window-mode-line-color "LightBlue"))

;; 
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)


;; カーソルのスクロールの設定
(setq scroll-conservatively 1)
(setq scroll-margin 2)

;; ホイールのスクロールの設定
;; 通常: 1 line
;; shift押しながら: 2 lines
;; ctrl押しながら: 6 lines
(setq mouse-wheel-scroll-amount '(1 ((shift) . 2) ((control) . 6)))
;; 高速にホイールした時に高速にスクロールされるのを防ぐ
(setq mouse-wheel-progressive-speed nil)


;; スクリプトの保存時に実行属性をつける
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; gdb mode
(setq gdb-many-windows t)

;; load my el
(try-load "my")
