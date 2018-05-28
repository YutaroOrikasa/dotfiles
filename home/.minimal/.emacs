;; reverse yank-pop
;; http://www.emacswiki.org/emacs/KillingAndYanking
(defun yank-pop-forwards (arg)
  (interactive "p")
  (yank-pop (- arg)))

(global-set-key "\M-Y" 'yank-pop-forwards) ; M-Y (Meta-Shift-Y)

(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])

(define-key global-map (kbd "C-h") 'backward-delete-char-untabify)

;; to mouse wheel scroll in gnu screen (ti@:te@ mode)
(xterm-mouse-mode t)
(global-set-key   [mouse-5] 'next-line)
(global-set-key   [mouse-4] 'previous-line)

;; スクリプトの保存時に実行属性をつける
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

