(deftheme myadwi
  "Created 2016-12-28.")

(custom-theme-set-variables
 'myadwi
 '(custom-safe-themes (quote ("7009f201dfa0c9a73fe2d0446307c9e29443da8b547d519548ab8c8ad4ceb597" default))))

(custom-theme-set-faces
 'myadwi
 '(cursor ((((class color) (min-colors 89)) (:background "#00BBFF"))))
 '(fringe ((((class color) (min-colors 89)) (:background "#E6E6E6"))))
 '(mode-line ((((class color) (min-colors 89)) (:box (:line-width -1 :style released-button) :background "white" :foreground "#2E3436"))))
 '(mode-line-inactive ((((class color) (min-colors 89)) (:foreground "#C6C6C6" :background "white"))))
 '(header-line ((((class color) (min-colors 89)) (:foreground "#CCCCCC" :background "black"))))
 '(minibuffer-prompt ((((class color) (min-colors 89)) (:foreground "#0084C8" :bold t))))
 '(region ((((class color) (min-colors 89)) (:background "#C2D5E9" :foreground unspecified))))
 '(dired-header ((((class color) (min-colors 89)) (:bold t :foreground "#0084C8"))))
 '(widget-button ((((class color) (min-colors 89)) (:bold t :foreground "#0084C8"))))
 '(success ((((class color) (min-colors 89)) (:bold t :foreground "#4E9A06"))))
 '(warning ((((class color) (min-colors 89)) (:foreground "#CE5C00"))))
 '(error ((((class color) (min-colors 89)) (:foreground "#B50000"))))
 '(font-lock-builtin-face ((((class color) (min-colors 89)) (:foreground "#A020F0"))))
 '(font-lock-constant-face ((((class color) (min-colors 89)) (:foreground "#F5666D"))))
 '(font-lock-comment-face ((((class color) (min-colors 89)) (:foreground "#204A87"))))
 '(font-lock-function-name-face ((((class color) (min-colors 89)) (:foreground "#00578E" :bold t))))
 '(font-lock-keyword-face ((((class color) (min-colors 89)) (:bold t :foreground "#A52A2A"))))
 '(font-lock-string-face ((((class color) (min-colors 89)) (:foreground "#4E9A06"))))
 '(font-lock-type-face ((((class color) (min-colors 89)) (:foreground "#2F8B58" :bold t))))
 '(font-lock-variable-name-face ((((class color) (min-colors 89)) (:foreground "#0084C8" :bold t))))
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:foreground "#F5666D" :bold t))))
 '(link ((((class color) (min-colors 89)) (:underline t :foreground "#0066CC"))))
 '(link-visited ((((class color) (min-colors 89)) (:underline t :foreground "#6799CC"))))
 '(highlight ((t (:background "light yellow"))))
 '(isearch ((((class color) (min-colors 89)) (:foreground "white" :background "#77A4DD"))))
 '(default ((((class color) (min-colors 89)) (:background "#EDEDED" :foreground "#2E3436")))))

(provide-theme 'myadwi)
