# Configurare .emacs

## melpa

Per avere i package emacs come prima cosa devi attaccare 
questo pezze di codice nel tuo .emacs fra le due istruzioni 
presenti di default 

* (require 'package)
* (package-initialize)

```
(require 'package)


(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))

(package-initialize)
```
Poi riapri emacs e:

``` 
 M-x package-refresh-contents
```

reference: http://melpa.org/#/getting-started

## use-package

use package deve essere installato  a  mano ...
e' il package che serve per gestire l'installazione degli altri package 

