;;; elscreen-renumber-create.el --- renumber elscreen and create screen

;; Copyright (C) 2015 momomo5717

;; Keywords: elscreen
;; Version: 0.1.0
;; Package-Requires: ((cl-lib "1.0") (elscreen "20140421.414"))
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
;;
;; Usage
;;  (require 'elscreen-renumber-create)
;;  ;; example key bindings
;;  (define-key elscreen-map (kbd "t") 'elscreen-renumber-create)
;;  (define-key elscreen-map (kbd "T") 'elscreen-renumber-create-right)

;;; Code:
(require 'cl-lib)
(require 'elscreen)

(defun elscreen-renumber-internal ()
  (cl-loop for i from 0 for s in (sort (elscreen-get-screen-list) '<) do
      (when (/= i s)
        (setcar (assoc s (elscreen-get-conf-list 'screen-property)) i)
        (setcar (member s (elscreen-get-conf-list 'screen-history)) i)
        (setcar (assoc s (elscreen-get-screen-to-name-alist-cache)) i))))

;;;###autoload
(defun elscreen-renumber ()
  (interactive)
  (elscreen-renumber-internal)
  (elscreen-tab-update t))

(defun elscreen--screen-limit-p ()
  (if (and (boundp 'elscreen-outof-limit-mode)
           elscreen-outof-limit-mode)
      (and (integerp elscreen-screen-limit-number)
           (>= (elscreen-get-number-of-screens)
               elscreen-screen-limit-number))
    (>= (elscreen-get-number-of-screens) 10)))

;;;###autoload
(defun elscreen-renumber-create ()
  (interactive)
  (if (elscreen--screen-limit-p)
      (message "No more screens.")
    (elscreen-renumber-internal)
    (elscreen-create)))

;;;###autoload
(defun elscreen-renumber-create-right ()
  (interactive)
  (if (elscreen--screen-limit-p)
      (message "No more screens.")
    (elscreen-renumber-internal)
    (let ((current-s-nth (1+ (elscreen-get-current-screen))))
      (cl-loop for i downfrom (elscreen-get-number-of-screens) to (1+ current-s-nth)
               for s in (sort (elscreen-get-screen-list) '>) do
          (when (/= i s)
            (setcar (assoc s (elscreen-get-conf-list 'screen-property)) i)
            (setcar (member s (elscreen-get-conf-list 'screen-history)) i)
            (setcar (assoc s (elscreen-get-screen-to-name-alist-cache)) i)))
      (elscreen-create))))

(provide 'elscreen-renumber-create)
;;; elscreen-renumber-create.el ends here
