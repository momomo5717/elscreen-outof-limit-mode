;;; helm-elscreen-outof-limit.el --- override helm-elscreen to adopt elscreen-outof-limit-mode

;; Copyright (C) 2015 momomo5717

;; Keywords: elscreen helm
;; Version: 0.1.0
;; Package-Requires: ((elscreen "20140421.414")(helm "20150114.140"))
;; URL: https://github.com/momomo5717/elscreen-outof-limit-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Tested on Emacs 24.4.1 (emacs-mac-app 5.2_0)
;;
;; Usage
;;
;;   (requrie 'helm-elscree-outof-limit)
;;   ;; example key bindings
;;   (define-key elscreen-map (kbd "h") 'helm-elscreen)
;;   (define-key elscreen-map (kbd "H") 'helm-elscreen-history)
;;

;;; Code:

(require 'helm-elscreen)

(declare-function elscreen-get-screen-to-name-alist "ext:elscreen.el" ())
(declare-function elscreen-get-conf-list "ext:elscreen.el" (type))

(defun helm--elscreen-goto-candidate (candidate)
  (elscreen-goto
   (string-to-int (substring candidate (string-match "[0-9]+" candidate 1)))))

(defun helm--elscreen-action-change-screen (candidate)
  (helm--elscreen-goto-candidate candidate))

(defun helm--elscreen-action-kill-screen (candidate)
  (cl-dolist (i (helm-marked-candidates))
    (helm--elscreen-goto-candidate i)
    (elscreen-kill)))

(defun helm--elscreen-action-only-screen (candidate)
  (helm--elscreen-goto-candidate candidate)
  (elscreen-kill-others))

(setq helm-source-elscreen
      `(,(assoc 'name helm-source-elscreen)
        ,(assoc 'candidates helm-source-elscreen)
        (action
         . (("Change Screen" .  helm--elscreen-action-change-screen)
            ("Kill Screen(s)" . helm--elscreen-action-kill-screen)
            ("Only Screen" .    helm--elscreen-action-only-screen)))))

(defvar helm-source-elscreen-history
  `((name . "Elscreen History")
    (candidates
     . (lambda ()
         (if (cdr (elscreen-get-screen-to-name-alist))
             (cl-loop with sname-als = (elscreen-get-screen-to-name-alist)
                   for screen in (cdr (elscreen-get-conf-list 'screen-history))
                   for sname = (assoc screen sname-als)
                   collect (format "[%d] %s" (car sname) (cdr sname))))))
    ,(assoc 'action helm-source-elscreen)))

;;;###autoload
(defun helm-elscreen-history ()
  (interactive)
  (helm-other-buffer helm-source-elscreen-history "*Helm ElScreen*"))

(provide 'helm-elscreen-outof-limit)

;;; helm-elscreen-outof-limit.el ends here
