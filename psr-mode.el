;; A minor mode for making OCR letter mistake mappings.
;;
;; For example, let us suppose the original string that was OCRd was
;;
;;     The quick brown fox jumps upon the lazy dog.
;;
;; And the OCR result was
;;
;;     The gaiek hiowii tox jumpa upoii the losy dog.
;;
;; In order to correct this we first note that the first wrong string
;; is "ga" in "gaiek", which is supposed to be "qu"
;;
;; Place the point on g, press `C-<Spc> ff` to select "ga" in the
;; region.
;;
;; Now press C-c h
;;
;; You will be prompted for a replacement string. Type qu <RET>
;;
;; You should now see that the sentence has been changed to
;;
;;     The <ga|qu>iek hiowii tox jumpa upoii the losy dog.
;;
;; The next wrong letter is c in `quick` which was read as e in
;; `gaiek`. So place the point on the e and press `C-c h c<RET>` to get
;;
;;     The <ga|qu>i<e|c>k hiowii tox jumpa upoii the losy dog.
;;
;; Note that you don't need to create a region for a single letter
;; replacement - keeping the point on the letter and pressing C-c h
;; will work. For multi-letter mistakes, however, you need to select
;; the wrong string in a region and then press C-c h to provide the
;; replacement for that wrong string.
;;
;; Continue this exercise to get the final result,
;;
;;     The <ga|qu>i<e|c>k <hi|br>ow<ii|n> <t|f>ox jump<a|s> upo<ii|n>
;;     the l<os|az>y dog.

(defmacro pos-1 ()
  '(if (use-region-p)
       (region-beginning)
     (point)))

(defmacro pos-2 ()
  '(if (use-region-p)
       (region-end)
     (progn
       (message "in the else")
       (1+ (point)))))

(defmacro replacement-point ()
  '(+ (point)
      (if (use-region-p) 2 3)))

(defun input-replacement (replacement-string)
  (interactive "sReplacement string: ")
  (let ((pos1 (pos-1))
        (pos2 (pos-2))
        (rpos (replacement-point)))
    (goto-char pos1)
    (insert "<")
    (goto-char (1+ pos2))
    (insert "|")
    (goto-char rpos)
    (insert replacement-string)
    (insert ">")))

(define-minor-mode psr-mode
  "PSR mode for OCR error recording"
  :lighter " psr"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c h") 'input-replacement)
            map))

(provide 'psr-mode)
