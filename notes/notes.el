;;; notes.el -- My notes  -*- lexical-binding: t; -*-

;;; Commentary:

;; Publish org documents to HTML.

;;; Code:

(require 'site)
(require 'ox-html)

(defconst notes/project-directory
  (file-name-directory (or load-file-name buffer-file-name)))

(defconst notes/org-project-alist

  ;; Publish org files to HTML files in the cfclrk.com project
  `(("notes"
     :recursive t
     :base-directory
     ,(expand-file-name "org" notes/project-directory)
     :publishing-directory
     ,(expand-file-name "notes" site/publishing-directory)
     :publishing-function site/org-html-publish-to-html
     :auto-sitemap t
     :sitemap-title "Notes"
     :html-head-include-scripts nil
     :html-head-include-default-style nil
     :with-creator nil
     :with-author nil
     :section-numbers nil
     :html-preamble site/site-preamble
     :html-self-link-headlines t
     :html-head
     "<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/main.css\" />")

    ;; Copy images to the cfclrk.com project
    ("notes-img"
     :recursive t
     :base-directory
     ,(expand-file-name "img" notes/project-directory)
     :publishing-directory
     ,(expand-file-name "img" site/publishing-directory)
     :base-extension "png\\|svg"
     :publishing-function org-publish-attachment)))

(provide 'notes)
;;; notes.el ends here
